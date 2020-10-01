defmodule HTTPStream.MixProject do
  use Mix.Project

  @version "0.2.0"
  @source_url "https://github.com/subvisual/http_stream"

  def project do
    [
      app: :http_stream,
      version: @version,
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      description: description(),
      docs: docs(),
      deps: deps(),
      package: package(),
      name: "HTTPStream",
      source_url: @source_url
    ]
  end

  def application do
    [
      extra_applications: [:logger, :httpoison]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:castore, "~> 0.1.7", optional: true},
      {:mint, "~> 1.1.0", optional: true},
      {:httpoison, "~> 1.7.0", optional: true},
      {:credo, "~> 1.5.0-rc.2", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:jason, "~> 1.2", only: [:dev, :test]},
      {:plug_cowboy, "~> 2.0", only: :test}
    ]
  end

  defp package do
    [
      licenses: ["ISC"],
      links: %{"GitHub" => @source_url},
      files: ~w(.formatter.exs mix.exs README.md CODE_OF_CONDUCT.md lib LICENSE)
    ]
  end

  defp description do
    "A tiny, tiny library to stream big big files. HTTPStream wraps HTTP requests into a Stream"
  end

  defp docs do
    [
      extras: ["README.md"],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}"
    ]
  end
end
