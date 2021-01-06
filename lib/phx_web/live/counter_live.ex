defmodule PhxWeb.CounterLive do
  alias Phoenix.LiveView, as: LV
  use Phoenix.LiveView
  use Agent
  require Logger
  import Ecto.Query
  alias Phx.Metrics

  def feedposts(metadata, back, tags) do
    query =
      if tags != "" do
        feed_ids =
          Phx.Repo.one(from t in FDTag, where: [name: ^tags], preload: [:fd_feed]).fd_feed

        feed_ids = Enum.map(feed_ids, & &1.id)
        Ecto.Query.from(p in FDFeedPost, where: p.fd_feed_id in ^feed_ids, order_by: [desc: p.id])
      else
        Ecto.Query.from(p in FDFeedPost, preload: [fd_feed: :tags], order_by: [desc: p.id])
      end

    if metadata == 0 do
      %{entries: entries, metadata: metadata} =
        Phx.Repo.paginate(query, cursor_fields: [:id, :desc], sort_direction: :desc, limit: 1)

      {entries, metadata}
    else
      if back do
        %{entries: entries, metadata: metadata} =
          Phx.Repo.paginate(query,
            before: metadata.before,
            cursor_fields: [:id, :desc],
            sort_direction: :desc,
            limit: 1
          )

        {entries, metadata}
      else
        %{entries: entries, metadata: metadata} =
          Phx.Repo.paginate(query,
            after: metadata.after,
            cursor_fields: [:id, :desc],
            sort_direction: :desc,
            limit: 1
          )

        {entries, metadata}
      end
    end
  end

  def render(assigns) do
    ~L"""
    <div class="posts" phx-window-keyup="keydown">
      <div>
          <%= for post <- @feedposts do %>
            <h3><a href="<%=  post.url %>"><%=  post.title %></a></h3>
        <div>
          <%= Phoenix.HTML.raw HtmlSanitizeEx.basic_html(post.content) %>
        </div>
        <% end %>

      </div>

      <div style="position: fixed; right: 20px; bottom: 20px;">
        <button id="navleft" phx-click="dec" phx-hook="ScrollToTop" phx-window-keyup="keydown">-</button>
        <button id="navright" phx-click="inc" phx-hook="ScrollToTop" phx-window-keyup="keydown">+</button>
      </div>
    </div>
    """
  end

  def mount(%{"tag" => tag} = params, _session, socket) do
    {entries, metadata} = feedposts(0, _back = false, tag)

    Agent.start_link(fn -> [0] end, name: Storage)
    Agent.update(Storage, fn _state -> metadata end)

    {:ok, assign(socket, val: 0, feedposts: entries, params: params)}
  end

  def mount(_params, _session, socket) do
    {entries, metadata} = feedposts(0, _back = false, "")

    Agent.start_link(fn -> [0] end, name: Storage)
    Agent.update(Storage, fn _state -> metadata end)

    {:ok, assign(socket, val: 0, feedposts: entries, params: %{"tag" => ""})}
  end

  def handle_event("inc", _value, socket) do
    Metrics.increment_page_turner()
    next = Agent.get(Storage, fn state -> state end)
    Logger.info(socket.assigns.params["tag"])
    {entries, metadata} = feedposts(next, _back = false, socket.assigns.params["tag"])
    Agent.update(Storage, fn _state -> metadata end)

    socket = assign(socket, :feedposts, entries)
    {:noreply, LV.update(socket, :val, &(&1 + 1))}
  end

  def handle_event("dec", _value, socket) do
    next = Agent.get(Storage, fn state -> state end)
    {entries, metadata} = feedposts(next, _back = true, socket.assigns.params["tag"])
    Agent.update(Storage, fn _state -> metadata end)

    socket = assign(socket, :feedposts, entries)

    # FIXME: Ensure val can never be set below 0.
    {:noreply, LV.update(socket, :val, &(&1 - 1))}
  end

  def handle_event("keydown", key, socket) do
    {:noreply, turn(socket, key["key"])}
  end

  defp turn(socket, "ArrowRight") do
    next = Agent.get(Storage, fn state -> state end)
    {entries, metadata} = feedposts(next, _back = false, socket.assigns.params["tag"])
    Agent.update(Storage, fn _state -> metadata end)

    socket = assign(socket, :feedposts, entries)
    LV.update(socket, :val, &(&1 + 1))
  end

  defp turn(socket, "ArrowLeft") do
    next = Agent.get(Storage, fn state -> state end)
    {entries, metadata} = feedposts(next, _back = true, socket.assigns.params["tag"])
    Agent.update(Storage, fn _state -> metadata end)

    socket = assign(socket, :feedposts, entries)
    LV.update(socket, :val, &(&1 - 1))
  end

  defp turn(socket, _), do: socket
end
