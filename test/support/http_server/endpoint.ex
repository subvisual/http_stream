defmodule HTTPStream.HTTPServer.Endpoint do
  use Plug.Router

  alias HTTPStream.HTTPServer

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:json], json_decoder: Jason
  plug :match
  plug :dispatch

  match _ do
    response_module =
      Application.get_env(:http_stream, HTTPServer)[:respond_with]

    response_module.call(conn)
  end
end
