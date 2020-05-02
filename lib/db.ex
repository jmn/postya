defmodule DB do
  require Logger
  require Ecto.Query

  def db() do
    uri = System.get_env("DATABASE_URL") |> URI.parse()
    [username, password] = String.split(uri.userinfo, ":")

    Logger.info("Connecting to database #{uri.path} on #{uri.host}")

    {:ok, pid} =
      Postgrex.start_link(
        hostname: uri.host,
        username: username,
        password: password,
        database: uri.path |> String.replace_leading("/", "")
      )

    {:ok, pid}
  end

  def feedsources(pid) do
    Postgrex.query!(pid, "SELECT (id, url) FROM fd_feed", []).rows
    |> Enum.flat_map(fn row -> row end)
  end

  def store_in_db_ecto(feedsource_id, entry) do
    datetime = DateTime.truncate(DateTime.utc_now(), :second)

    Logger.info("Storing #{entry.url}")

    content =
      if entry.content do
        entry.content
      else
        entry.summary
      end

    Phx.Repo.insert(
      %FDFeedPost{
        title: entry.title,
        url: entry.url,
        author: "fopo",
        content: content,
        date_acquired: datetime,
        date_published: datetime,
      },
      on_conflict: :nothing
    )
  end

  def store_in_db(feedsource_id, entry, pid) do
    # {:ok, datetime, 0} = DateTime.from_iso8601(entry.updated)
    datetime = DateTime.utc_now()
    Logger.info("Storing #{entry.url}")

    Postgrex.query!(pid, "INSERT INTO fd_feedpost (title, url, author, content, date_acquired,
      date_published, feed_id) VALUES ($1, $2, $3, $4, $5, $6, $7)
      ON CONFLICT DO NOTHING", [
      entry.title,
      entry.url,
      "fopo",
      entry.content,
      datetime,
      datetime,
      feedsource_id
    ])

    Logger.info("Stored #{entry.title} in DB")
  end
end
