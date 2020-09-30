defmodule HTTPStream.HTTPCase do
  use ExUnit.CaseTemplate, async: false

  alias HTTPStream.HTTPServer

  using do
    quote do
      import HTTPStream.HTTPHelpers
    end
  end

  setup tags do
    config = Application.get_env(:http_stream, HTTPServer)

    response_module =
      case tags[:respond_with] do
        nil -> HTTPServer.RespondWithRequest
        module -> module
      end

    Application.put_env(:http_stream, HTTPServer,
      port: config[:port],
      respond_with: response_module
    )

    {:ok, _pid} = HTTPServer.start()

    on_exit(fn ->
      HTTPServer.stop()
      Application.put_env(:http_stream, HTTPServer, config)
    end)

    :ok
  end
end
