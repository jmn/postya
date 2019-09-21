defmodule PhxWeb.PageController do
  use PhxWeb, :controller

  def index(conn, _params) do
    Phoenix.Controller.render(conn, "index.html")
  end
end
