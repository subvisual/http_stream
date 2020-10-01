if Code.ensure_loaded?(Mint.HTTP) do
  defmodule HTTPStream.Adapter.Mint do
    @moduledoc """
    Implements `HTTPStream.Adapter` for the Mint HTTP Client.
    """

    alias HTTPStream.Request

    @behaviour HTTPStream.Adapter

    @impl true
    def request(%Request{} = request) do
      with {:ok, conn} <- connect(request),
           {:ok, conn, ref} <- do_request(conn, request) do
        {conn, ref, :continue}
      end
    end

    @impl true
    def parse_chunks({conn, ref, :halt}) do
      {:halt, {conn, ref}}
    end

    def parse_chunks({conn, ref, :continue}) do
      case Mint.HTTP.recv(conn, 0, :infinity) do
        {:ok, conn, chunks} ->
          handle_chunks(conn, ref, chunks)

        {:error, conn, _error, chunks} ->
          {chunks, {conn, ref, :halt}}
      end
    end

    @impl true
    def close({conn, _ref}), do: do_close(conn)
    def close({conn, _ref, :halt}), do: do_close(conn)

    defp connect(%Request{scheme: scheme, host: host, port: port}) do
      Mint.HTTP.connect(scheme, host, port, mode: :passive)
    end

    defp do_request(conn, request) do
      Mint.HTTP.request(
        conn,
        request.method,
        request.path,
        request.headers,
        request.body
      )
    end

    defp handle_chunks(conn, ref, chunks) do
      next =
        if Enum.any?(chunks, &done?/1) do
          :halt
        else
          :continue
        end

      {filter_data(chunks), {conn, ref, next}}
    end

    defp do_close(conn) do
      Mint.HTTP.close(conn)
      :ok
    end

    defp filter_data(chunks) do
      Stream.filter(chunks, &data?/1)
      |> Enum.map(fn {:data, _ref, chunk} -> chunk end)
    end

    defp done?(message) do
      elem(message, 0) == :done
    end

    defp data?(message) do
      elem(message, 0) == :data
    end
  end
end
