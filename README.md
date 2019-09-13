HTTPStream
==========

HTTPStream is a tiny, tiny package that wraps HTTP requests into a `Stream` so
that you can manage data on the fly, without keeping everything in memory.

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

**Table of Contents**

* [Installation](#installation)
* [Development](#development)
* [Contribution Guidelines](#contribution-guidelines)
* [About](#about)

Installation
------------

First, you need to add `http_stream` to your list of dependencies on `mix.exs`:

```elixir
def deps do
  [
    {:http_stream, "~> 0.1.0"}
  ]
end
```

Development
-----------

If you want to setup the project for local development, you can just run the
following commands.

```
git clone git@github.com:subvisual/http_stream.git
cd http_stream
bin/setup
```

PRs and issues welcome.

### TODOs

- [ ] Add remaining HTTP requests
- [ ] Add tests
- [ ] Add documentation

Contribution Guidelines
-----------------------

Contributions must follow [Subvisual's guides](https://github.com/subvisual/guides).

About
-----

HTTPStream is maintained by [Subvisual](http://subvisual.co).

[![Subvisual](https://raw.githubusercontent.com/subvisual/guides/master/github/templates/subvisual_logo_with_name.png)](http://subvisual.co)

If you need to contact the maintainer, you may <a href="mailto:contact@subvisual.co">reach out to us</a>.


[zstream]: https://github.com/ananthakumaran/zstream
