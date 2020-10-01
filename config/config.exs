use Mix.Config

config :http_stream, adapter: HTTPStream.Adapter.Mint

import_config "#{Mix.env()}.exs"
