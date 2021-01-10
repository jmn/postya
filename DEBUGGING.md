# Debugging read.jmnorlund.net

`iex -S mix`

## Local configuration
- set environment variable `DATABASE_URL`.

## Testing a query
```elixir

db = DB.db()

import Ecto.Query
query = from(f in FDFeed, select: f)
fs = Phx.Repo.all(query) |> Enum.map((fn item -> {item.id, item.url} end))

# Debug fetch
Dl.download({1, "https://boingboing.net/feed"})
```

## Debugging feeds
```elixir

import ElixirFeedParser
import Dl
feed_url = "https://www.lpalmieri.com/rss.xml"
feed = Dl.download({1, feed_url})
{:ok, _, body ,_  } = feed
ElixirFeedParser.parse(body)

```
