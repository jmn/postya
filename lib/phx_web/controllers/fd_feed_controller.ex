defmodule PhxWeb.FDFeedController do
  use PhxWeb, :controller

  alias Phx.Feeds

  def index(conn, _params) do
    fd_feed = Feeds.list_fd_feed()
    render(conn, "index.html", fd_feed: fd_feed)
  end

  def new(conn, _params) do
    changeset = Feeds.change_fd_feed(%FDFeed{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"fd_feed" => fd_feed_params}) do
    case Feeds.create_fd_feed(fd_feed_params) do
      {:ok, fd_feed} ->
        conn
        |> put_flash(:info, "Fd feed created successfully.")
        |> redirect(to: Routes.fd_feed_path(conn, :show, fd_feed))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    fd_feed = Feeds.get_fd_feed!(id)
    render(conn, "show.html", fd_feed: fd_feed)
  end

  def edit(conn, %{"id" => id}) do
    fd_feed = Feeds.get_fd_feed!(id)
    changeset = Feeds.change_fd_feed(fd_feed)
    render(conn, "edit.html", fd_feed: fd_feed, changeset: changeset)
  end

  def update(conn, %{"id" => id, "fd_feed" => fd_feed_params}) do
    fd_feed = Feeds.get_fd_feed!(id)

    case Feeds.update_fd_feed(fd_feed, fd_feed_params) do
      {:ok, fd_feed} ->
        conn
        |> put_flash(:info, "Fd feed updated successfully.")
        |> redirect(to: Routes.fd_feed_path(conn, :show, fd_feed))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", fd_feed: fd_feed, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    fd_feed = Feeds.get_fd_feed!(id)
    {:ok, _fd_feed} = Feeds.delete_fd_feed(fd_feed)

    conn
    |> put_flash(:info, "Fd feed deleted successfully.")
    |> redirect(to: Routes.fd_feed_path(conn, :index))
  end
end
