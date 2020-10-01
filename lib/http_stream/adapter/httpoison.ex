if Code.ensure_loaded?(HTTPoison) do
  defmodule HTTPStream.Adapter.HTTPoison do
    @moduledoc """
    Implements `HTTPStream.Adapter` for the HTTPoison client.

    HTTPoison performs async requests through messages. This means there is an implicit timeout if, for some reason, the server stops responding. By default this timeout is `30_000` (in milliseconds) but can be configured by setting in your `config/config.exs` file:

    ```
    config :http_stream, HTTPStream.Adapter.HTTPoison, timeout: 60_000

    ```
    """

    alias HTTPStream.Request

    @behaviour HTTPStream.Adapter

    @default_timeout 30_000

    @impl true
    def request(%Request{} = request) do
      HTTPoison.request(
        request.method,
        Request.url_for(request),
        request.body,
        request.headers,
        async: :once,
        stream_to: self()
      )
    end

    @impl true
    def parse_chunks({:ok, %HTTPoison.AsyncResponse{} = response}) do
      parse_chunks(response)
    end

    def parse_chunks(%HTTPoison.AsyncResponse{id: id} = response) do
      receive do
        %HTTPoison.AsyncChunk{id: ^id, chunk: chunk} ->
          HTTPoison.stream_next(response)
          {[chunk], response}

        %HTTPoison.AsyncEnd{id: ^id} ->
          {:halt, response}

        _ ->
          HTTPoison.stream_next(response)
          {[], response}
      after
        timeout() ->
          {:halt, response}
      end
    end

    # See: https://github.com/edgurgel/httpoison/issues/103
    @impl true
    def close(%HTTPoison.AsyncResponse{id: id}) do
      :hackney.stop_async(id)
    end

    defp timeout do
      config = Application.get_env(:http_stream, __MODULE__)
      config[:timeout] || @default_timeout
    end
  end
end
