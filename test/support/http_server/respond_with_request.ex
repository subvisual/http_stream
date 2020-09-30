defmodule HTTPStream.HTTPServer.RespondWithRequest do
  def call(conn) do
    headers = Enum.into(conn.req_headers, %{})
    params = Enum.into(conn.params, %{})

    response = Jason.encode!(%{headers: headers, params: params})

    Plug.Conn.send_resp(conn, 200, response)
  end
end
