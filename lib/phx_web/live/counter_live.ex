defmodule PhxWeb.CounterLive do
  use Phoenix.LiveView
  require Logger

  def feedposts() do
      Phx.Repo.all(FDFeedPost)
  end
  
  def render(assigns) do
    ~L"""
    <div>
      <h1>The count is: <%= @val %></h1>
      <button phx-click="dec">-</button>
      <button phx-click="inc">+</button>
    </div>

    <div>
        <%= for post <- @feedposts do %>
    	    <h3><%=  post.title %></h3>
	    <p><%= Phoenix.HTML.raw HtmlSanitizeEx.basic_html(post.content) %></p>
       <% end %>

    </div>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, val: 0, feedposts: feedposts())}
  end

  def handle_event("inc", _value, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("dec", _value, socket) do
    {:noreply, update(socket, :val, &(&1 - 1))}
  end
end
