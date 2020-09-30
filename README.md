# HTTPStream

![Build][build-badge]

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
    {:http_stream, "~> 0.1.0"}
  ]
end
```

## Development

If you want to setup the project for local development, you can just run the
following commands.

```
git clone git@github.com:subvisual/http_stream.git
cd http_stream
bin/setup
```

PRs and issues welcome.

### TODOs

* [ ] Add remaining HTTP requests
* [ ] Add tests
* [ ] Add documentation

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
[zstream]: https://github.com/ananthakumaran/zstream
[subvisual]: https://subvisual.com
[subvisual-guides]: https://github.com/subvisual/guides
[subvisual-logo]: https://raw.githubusercontent.com/subvisual/guides/master/github/templates/logos/blue.png
[coc]: https://github.com/subvisual/http_stream/blob/master/CODE_OF_CONDUCT.md
