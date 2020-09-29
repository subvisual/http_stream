defmodule HTTPStream.HTTPServer do
  alias HTTPStream.MockEndpoint

  @default_port 3000

  def start(port \\ @default_port) do
    Plug.Cowboy.http(MockEndpoint, [], port: port)
  end

  def stop, do: Plug.Cowboy.shutdown(MockEndpoint.HTTP)
end
