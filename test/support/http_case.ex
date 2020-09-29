defmodule HTTPStream.HTTPCase do
  use ExUnit.CaseTemplate, async: false

  using do
    quote do
      import HTTPStream.HTTPHelpers
    end
  end

  setup do
    {:ok, _pid} = HTTPStream.HTTPServer.start()

    on_exit(fn ->
      HTTPStream.HTTPServer.stop()
    end)

    :ok
  end
end
