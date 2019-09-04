# HTTPStream

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `http_stream` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:http_stream, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/http_stream](https://hexdocs.pm/http_stream).

## Examples

Downloading an image:

```elixir
image_url
|> HTTPStream.get()
|> Stream.into(File.stream!("image.png"))
|> Stream.run()
```

Streaming multiple images into a ZIP archive (using [zstream](zstream))

```elixir
[
  Zstream.entry("a.png", HTTPStream.get(a_url))
  Zstream.entry("b.png", HTTPStream.get(b_url))
]
|> Zstream.zip()
|> Stream.into(File.stream!("archive.zip"))
|> Stream.run()
```

zstream: https://github.com/ananthakumaran/zstream
