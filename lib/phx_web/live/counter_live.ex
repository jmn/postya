defmodule PhxWeb.CounterLive do
  use Phoenix.LiveView
  use Agent
  require Logger
  require Ecto.Query

  def feedposts(metadata, back) do
    query = Ecto.Query.from(p in FDFeedPost, order_by: [desc: p.id])

    if metadata == 0 do
      %{entries: entries, metadata: metadata} =
        Phx.Repo.paginate(query, cursor_fields: [:id], sort_direction: :desc, limit: 1)

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
            <h3><%=  post.title %> (<%=  post.id %>)</h3>
        <div>
          <%= Phoenix.HTML.raw HtmlSanitizeEx.basic_html(post.content) %>
        </div>
        <% end %>

      </div>

      <div style="position: fixed; right: 20px; bottom: 20px;">
        <button phx-click="dec" phx-hook="ScrollToTop">-</button>
        <button phx-click="inc" phx-hook="ScrollToTop">+</button>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {entries, metadata} = feedposts(0, back = false)

    Agent.start_link(fn -> [0] end, name: Storage)
    Agent.update(Storage, fn state -> metadata end)

    {:ok, assign(socket, val: 0, feedposts: entries)}
  end

  def handle_event("inc", _value, socket) do
    next = Agent.get(Storage, fn state -> state end)
    {entries, metadata} = feedposts(next, back = false)
    Agent.update(Storage, fn state -> metadata end)

    socket = assign(socket, :feedposts, entries)
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("dec", _value, socket) do
    next = Agent.get(Storage, fn state -> state end)
    {entries, metadata} = feedposts(next, back = true)
    Agent.update(Storage, fn state -> metadata end)

    socket = assign(socket, :feedposts, entries)

    # FIXME: Ensure val can never be set below 0.
    {:noreply, update(socket, :val, &(&1 - 1))}
  end

  def handle_event("keydown", key, socket) do
    {:noreply, turn(socket, key["code"])}
  end

  defp turn(socket, "ArrowRight") do
    next = Agent.get(Storage, fn state -> state end)
    {entries, metadata} = feedposts(next, back = false)
    Agent.update(Storage, fn state -> metadata end)

    socket = assign(socket, :feedposts, entries)
    update(socket, :val, &(&1 + 1))
  end

  defp turn(socket, "ArrowLeft") do
    next = Agent.get(Storage, fn state -> state end)
    {entries, metadata} = feedposts(next, back = true)
    Agent.update(Storage, fn state -> metadata end)

    socket = assign(socket, :feedposts, entries)
    update(socket, :val, &(&1 - 1))
  end

  defp turn(socket, _), do: socket
end
