defmodule PhxWeb.PageController do
  use PhxWeb, :controller

  def index(conn, _params) do
    Phoenix.Controller.render(conn, "index.html")
  end

  def protected(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, "protected.html", current_user: user)
  end
end
