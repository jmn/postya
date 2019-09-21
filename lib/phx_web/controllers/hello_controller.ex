defmodule PhxWeb.HelloController do
  use PhxWeb, :controller

  def index(conn, _params) do
    Phoenix.Controller.render(conn, "index.html")
  end

  def show(conn, %{"messenger" => messenger}) do
    render(conn, "show.html", messenger: messenger)
  end
end
