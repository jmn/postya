defmodule PhxWeb.ChatLive do
  use Phoenix.LiveView
  alias Phx.Communication
  require Logger

  defp topic(chat_id), do: "chat:#{chat_id}"

  def render(assigns) do
    PhxWeb.ChatView.render("show.html", assigns)
  end

  def mount(%{user: user}, socket) do
    PhxWeb.Endpoint.subscribe(topic(1))
    # Referencing parent assigns:
    # https://github.com/phoenixframework/phoenix_live_view/blob/c7ea73ba9223e2cf285fb970cd9090f92183ed80/lib/phoenix_live_view.ex#L610
    username = if user do
      user.email
    else
      "Anonymous"
    end

    {:ok, assign(socket, messages: Communication.list_messages(),
                        message: Communication.change_message(),
                        user: username
                        )}
  end

  def handle_event("message", %{"message" => %{"message" => ""}}, socket) do
    {:noreply, socket}
  end

  def handle_event("message", %{"message" => message_params}, socket) do
    messages = Communication.create_message(message_params)
    PhxWeb.Endpoint.broadcast_from(self(), topic(1), "message", %{messages: messages})

    {:noreply, assign(socket, message: Communication.change_message(), messages: messages)}
  end

  def handle_info(%{event: "message", payload: state}, socket) do
    {:noreply, assign(socket, state)}
  end

  def handle_event("typing", _value, socket) do
    {:noreply, socket}
  end

  def handle_event(
    "stop_typing",
    _value,
    socket
  ) do
{:noreply, socket}
end

end
