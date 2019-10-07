defmodule PhxWeb.ChatController do
  use PhxWeb, :controller
  alias Phoenix.LiveView

  alias PhxWeb.ChatLive
  alias Phx.Communication

  def index(conn, _params) do
    chats = Communication.list_messages()
    render(conn, "index.html", chats: chats)
  end

  def show(conn, %{"id" => chat_id}) do
    chat = chat_id

    LiveView.Controller.live_render(
      conn,
      ChatLive,
      session: %{chat: chat, user: Guardian.Plug.current_resource(conn)}
    )
  end
end
