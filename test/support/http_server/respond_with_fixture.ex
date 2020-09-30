defmodule HTTPStream.HTTPServer.RespondWithFixture do
  @fixture Path.dirname(__DIR__)
           |> Path.join("../fixtures/large.tif")
           |> Path.expand()

  import Plug.Conn

  def call(conn) do
    conn =
      conn
      |> put_resp_content_type("image/event-stream")
      |> put_resp_header(
        "Content-disposition",
        "attachment; filename=\"large.tif\""
      )
      |> put_resp_header("Content-Type", "application/octet-stream")
      |> send_chunked(200)

    File.stream!(@fixture)
    |> Stream.map(&chunk(conn, &1))
    |> Stream.run()
  end
end
