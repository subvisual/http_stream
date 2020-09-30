defmodule HTTPStream.HTTPServer do
  alias HTTPStream.HTTPServer.Endpoint

  @default_port 3000

  def start(port \\ @default_port) do
    Plug.Cowboy.http(Endpoint, [], port: port)
  end

  def stop, do: Plug.Cowboy.shutdown(Endpoint.HTTP)
end
