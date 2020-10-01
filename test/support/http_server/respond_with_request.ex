defmodule HTTPStream.HTTPServer.RespondWithRequest do
  def call(conn) do
    headers = Enum.into(conn.req_headers, %{})
    params = Enum.into(conn.params, %{})
    method = conn.method

    request = %{
      headers: headers,
      params: params,
      method: method
    }

    response = Jason.encode!(request)

    Plug.Conn.send_resp(conn, 200, response)
  end
end
