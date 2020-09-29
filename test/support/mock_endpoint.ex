defmodule HTTPStream.MockEndpoint do
  use Plug.Router

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:json], json_decoder: Jason
  plug :match
  plug :dispatch

  match _ do
    headers = Enum.into(conn.req_headers, %{})
    params = Enum.into(conn.params, %{})
    response = %{headers: headers, params: params}

    send_resp(conn, 200, Jason.encode!(response))
  end
end
