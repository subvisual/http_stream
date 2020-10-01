# HTTPStream

[![Build][build-badge]][build]

HTTPStream is a tiny, tiny package that wraps HTTP requests into a `Stream` so
that you can manage data on the fly, without keeping everything in memory.

Downloading an image:

```elixir
HTTPStream.get(large_image_url)
|> Stream.into(File.stream!("large_image.png"))
|> Stream.run()
```

Streaming multiple images into a ZIP archive (using [zstream][zstream])

```elixir
[
  Zstream.entry("a.png", HTTPStream.get(a_url))
  Zstream.entry("b.png", HTTPStream.get(b_url))
]
|> Zstream.zip()
|> Stream.into(File.stream!("archive.zip"))
|> Stream.run()
```

## Table of Contents

* [Installation](#installation)
* [Development](#development)
* [Contributing](#contributing)
* [About](#about)

## Installation

First, you need to add `http_stream` to your list of dependencies on `mix.exs`:

```elixir
def deps do
  [
    {:http_stream, "~> 0.2.0"},

    # if using the Mint adapter:
    {:castore, "~> 0.1.7"},
    {:mint, "~> 1.1.0"}

    # if using the HTTPoison adapter:
    {:httpoison, "~> 1.7.0"}
  ]
end
```

HTTPStream comes with two adapters: [`Mint`][mint] and [`HTTPoison`][httpoison].
By default `Mint` is configured but you need to include it in your dependencies.

To use `HTTPoison`, set in your `config/config.exs`:

```elixir
config :http_stream, adapter: HTTPStream.Adapter.HTTPoison
```

That's it! For more intricate API details, refer to the [documentation][docs].

## Development

If you want to setup the project for local development, you can just run the
following commands.

```
git clone git@github.com:subvisual/http_stream.git
cd http_stream
bin/setup
```

PRs and issues welcome.

## Contributing

Feel free to contribute!

If you found a bug, open an issue. You can also open a PR for bugs or new
features. Your PRs will be reviewed and subjected to our styleguide and linters.

All contributions **must** follow the [Code of Conduct][coc]
and [Subvisual's guides][subvisual-guides].

## About

HTTPStream is maintained with ❤️  by [Subvisual][subvisual].

<br>

![Subvisual][subvisual-logo]

[build-badge]: https://github.com/subvisual/http_stream/workflows/build/badge.svg
[build]: https://github.com/subvisual/http_stream/actions?query=workflow%3Abuild
[zstream]: https://github.com/ananthakumaran/zstream
[mint]: https://github.com/elixir-mint/mint
[httpoison]: https://github.com/edgurgel/httpoison
[docs]: https://hexdocs.pm/http_stream
[subvisual]: https://subvisual.com
[subvisual-guides]: https://github.com/subvisual/guides
[subvisual-logo]: https://raw.githubusercontent.com/subvisual/guides/master/github/templates/logos/blue.png
[coc]: https://github.com/subvisual/http_stream/blob/master/CODE_OF_CONDUCT.md
