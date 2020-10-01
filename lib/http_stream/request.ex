defmodule HTTPStream.Request do
  @moduledoc """
  Struct that represents a request.

  Fields:

  * `scheme`: `atom()` - e.g. `:http`
  * `host`: `binary()` - e.g. `"localhost"`
  * `port`: `integer()` - e.g. `80`
  * `path`: `binary()` - e.g `"/users/1/avatar.png"`
  * `method`: `String.t()` - e.g. `"GET"`
  * `headers`: `keyword()` - e.g. `[authorization: "Bearer 123"]`
  * `body`: `binary()` - e.g. `{ "id": "1" }`
  """

  @supported_methods ~w(GET POST)

  defstruct scheme: nil,
            host: nil,
            port: 80,
            path: "/",
            method: "GET",
            headers: [],
            body: ""

  @type t :: %__MODULE__{
          scheme: atom() | nil,
          host: binary() | nil,
          port: integer(),
          path: binary(),
          method: String.t(),
          headers: keyword(),
          body: binary()
        }

  @doc """
  Parses a given URL and uses a given method to generate a valid
  `HTTPStream.Request` struct.

  Supported options:

  * `headers` - HTTP headers to be sent.
  * `body` - Body of the HTTP request. This will be the request `query` field
  if the method is "GET".

  This function raises an `ArgumentError` if the HTTP method is unsupported or
  the `url` argument isn't a string.
  """
  @spec new(String.t(), String.t(), keyword()) :: t() | no_return()
  def new(method, url, opts \\ [])

  def new(method, url, opts)
      when is_binary(url) and method in @supported_methods do
    uri = URI.parse(url)
    scheme = String.to_atom(uri.scheme)
    headers = Keyword.get(opts, :headers, [])
    {body, query} = body_and_query_from_method(method, opts)
    path = encode_query_params(uri.path || "/", query)

    %__MODULE__{
      scheme: scheme,
      host: uri.host,
      port: uri.port,
      path: path,
      method: method,
      headers: headers,
      body: body
    }
  end

  def new(method, _, _) when method not in @supported_methods do
    supported_methods = Enum.join(@supported_methods, ", ")
    msg = "#{method} is not supported. Supported methods: #{supported_methods}"

    raise ArgumentError, msg
  end

  def new(_, _, _) do
    raise ArgumentError, "URL must be a string"
  end

  defp encode_query_params(path, []), do: path

  defp encode_query_params(path, query) do
    path <> "?" <> URI.encode_query(query)
  end

  defp body_and_query_from_method("GET", opts) do
    query = Keyword.get(opts, :body, [])
    {"", query}
  end

  defp body_and_query_from_method(_, opts) do
    body = Keyword.get(opts, :body, "")
    {body, []}
  end
end
