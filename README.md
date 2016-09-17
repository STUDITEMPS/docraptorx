# Docraptorx
[![hex.pm version](https://img.shields.io/hexpm/v/docraptorx.svg)](https://hex.pm/packages/docraptorx)
[![hex.pm](https://img.shields.io/hexpm/l/docraptorx.svg)](https://github.com/asacraft/docraptorx/blob/master/LICENSE)

Elixir library to access [Docraptor API](https://docraptor.com/documentation).

## Installation

Add `docraptorx` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:docraptorx, "~> 0.1.0"}]
end
```

## Usage

```elixir
Docraptorx.configure("your api key")

Docraptorx.create!(document_type: "pdf",
                   document_content: "<html><body>Hello World!</body></html>"
                   name: "hello.pdf",
                   async: true)
#=> %{"status_id": "a4096ef2-fde6-48f5-bbeb-ce2ad6873098"}

Docraptorx.status!("a4096ef2-fde6-48f5-bbeb-ce2ad6873098")
#=> %{"status" => "completed", "download_id" => "...", "download_url" => "...", "number_of_pages" => 1}
```

## Example

https://github.com/asacraft/docraptorx_example
