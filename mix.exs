defmodule HTTPStream.MixProject do
  use Mix.Project

  @env Mix.env()

  def project do
    [
      app: :http_stream,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:castore, "~> 0.1.0"},
      {:mint, "~> 0.2.0"}
      | deps(@env)
    ]
  end

  defp deps(env) when env in [:dev, :test] do
    [
      {:credo, "~> 1.0.0", runtime: false}
    ]
  end

  defp deps(_), do: []
end
