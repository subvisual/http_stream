defmodule HTTPStream.HTTPHelpers do
  def parse_response(stream) do
    stream
    |> Enum.join("")
    |> Jason.decode!()
  end
end
