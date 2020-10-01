defmodule HTTPStream do
  @moduledoc """
  Main API interface.

  HTTPStream is a tiny tiny library for streaming big big files. It works by
  wrapping HTTP requests onto a Stream. You can use it with Flow, write it to
  disk through regular streams and more!

  ```
  HTTPStream.get(large_image_url)
  |> Stream.into(File.stream!("large_image.png"))
  |> Stream.run()
  ```

  The adapter can be configured by setting in your `config/config.exs`:

  ```
  config :http_stream, adapter: HTTPStream.Adapter.Mint
  ```

  At the moment, only the Mint adapter is supported.
  """

  alias HTTPStream.Adapter
  alias HTTPStream.Request

  @type method :: String.t()

  @doc """
  Performs a GET request.

  Supported options:

  * `:headers` (default: `[]`) - Keyword list of HTTP headers to add to the request.
  * `:query` (default: `[]`) - Keyword list of query params to add to the request.
  """

  @spec get(String.t(), keyword()) :: Stream.t()
  def get(url, opts \\ []) do
    headers = Keyword.get(opts, :headers, []) |> to_keyword()
    query = Keyword.get(opts, :query, [])

    request("GET", url, headers, query)
  end

  def post(url, opts \\ []) do
    headers = Keyword.get(opts, :headers, []) |> to_keyword()
    params = Keyword.get(opts, :params, "") |> to_json()

    request("POST", url, headers, params)
  end

  @doc """
  Performs an HTTP request.

  Supported methods: GET
  """

  @spec request(method(), String.t(), keyword(), binary()) :: Stream.t()
  def request(method, url, headers \\ [], body \\ "") do
    Request.new(method, url, headers: headers, body: body)
    |> do_request()
  end

  defp do_request(%Request{} = request) do
    Stream.resource(
      fn -> adapter().request(request) end,
      &adapter().parse_chunks/1,
      &adapter().close/1
    )
  end

  defp to_keyword(enum) do
    Stream.map(enum, fn {k, v} -> {to_string(k), v} end)
    |> Enum.to_list()
  end

  defp to_json(term), do: Jason.encode!(term)

  defp adapter, do: Application.get_env(:http_stream, :adapter, Adapter.Mint)
end
