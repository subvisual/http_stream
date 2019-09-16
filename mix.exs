defmodule HTTPStream.MixProject do
  use Mix.Project

  @env Mix.env()
  @github_url "https://github.com/subvisual/http_stream"

  def project do
    [
      app: :http_stream,
      version: "0.1.2",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      source_url: @github_url,
      description: "A tiny, tiny package that wraps HTTP requests into a Stream"
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
      {:credo, "~> 1.0.0", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp deps(_), do: []

  defp package do
    [
      licenses: ["ISC"],
      links: %{"GitHub" => @github_url}
    ]
  end
end
