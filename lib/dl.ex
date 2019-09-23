defmodule Dl do
  require Logger
  require HTTPoison
  require HTTPoison.Error
  require ProgressBar
  require ElixirFeedParser
  import Ecto.Query
  
  def download({feedsource_id, url}) do
    case HTTPoison.get(url) do
      {:ok, response} ->
        case response.status_code do
          200 ->
            {:ok, feedsource_id, response.body, response.request_url}

          _ ->
            {:error, {response.status_code, response.request_url, response.body}}
        end

      {:error, err} ->
        {:error, err}
    end
  end

  def show_progress(flow, total) do
    flow
    |> Flow.partition(stages: 1)
    |> Flow.reduce(fn -> 0 end, fn _, count ->
      ProgressBar.render(count + 1, total, suffix: :count)
      count + 1
    end)
  end

  def handle_result(result) do
    case result do
      {:ok, feedsource_id, body, req_url} ->
        feed = ElixirFeedParser.parse(body)

        case feed do
          {:error, err} ->
            Logger.error("Error #{inspect(err)} for #{req_url}")

          _ ->
            Enum.each(feed.entries, fn e -> DB.store_in_db_ecto(feedsource_id, e) end)
            Logger.info("Feed: #{inspect(feed.title)}")
        end

      {:error, err} ->
        Logger.error("Error #{inspect(err)}")

      _ ->
        Logger.error("Error (unhandled)")
    end
  end

  def run() do
    Logger.info("Starting")
    #{:ok, db_pid} = DB.db()

#    fs = DB.feedsources(db_pid)

    query = from(f in FDFeed, select: f)
    fs = Phx.Repo.all(query) |> Enum.map((fn item -> {item.id, item.url} end))

    fs
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.map(&download/1)
    |> Flow.map(&handle_result(&1))
    |> show_progress(length(fs))
    |> Flow.run()
  end
end
