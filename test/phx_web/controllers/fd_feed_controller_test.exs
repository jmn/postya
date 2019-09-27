defmodule PhxWeb.FDFeedControllerTest do
  use PhxWeb.ConnCase

  alias Phx.Feeds

  @create_attrs %{url: "some url"}
  @update_attrs %{url: "some updated url"}
  @invalid_attrs %{url: nil}

  def fixture(:fd_feed) do
    {:ok, fd_feed} = Feeds.create_fd_feed(@create_attrs)
    fd_feed
  end

  describe "index" do
    test "lists all fd_feed", %{conn: conn} do
      conn = get(conn, Routes.fd_feed_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Fd feed"
    end
  end

  describe "new fd_feed" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.fd_feed_path(conn, :new))
      assert html_response(conn, 200) =~ "New Fd feed"
    end
  end

  describe "create fd_feed" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.fd_feed_path(conn, :create), fd_feed: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.fd_feed_path(conn, :show, id)

      conn = get(conn, Routes.fd_feed_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Fd feed"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.fd_feed_path(conn, :create), fd_feed: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Fd feed"
    end
  end

  describe "edit fd_feed" do
    setup [:create_fd_feed]

    test "renders form for editing chosen fd_feed", %{conn: conn, fd_feed: fd_feed} do
      conn = get(conn, Routes.fd_feed_path(conn, :edit, fd_feed))
      assert html_response(conn, 200) =~ "Edit Fd feed"
    end
  end

  describe "update fd_feed" do
    setup [:create_fd_feed]

    test "redirects when data is valid", %{conn: conn, fd_feed: fd_feed} do
      conn = put(conn, Routes.fd_feed_path(conn, :update, fd_feed), fd_feed: @update_attrs)
      assert redirected_to(conn) == Routes.fd_feed_path(conn, :show, fd_feed)

      conn = get(conn, Routes.fd_feed_path(conn, :show, fd_feed))
      assert html_response(conn, 200) =~ "some updated url"
    end

    test "renders errors when data is invalid", %{conn: conn, fd_feed: fd_feed} do
      conn = put(conn, Routes.fd_feed_path(conn, :update, fd_feed), fd_feed: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Fd feed"
    end
  end

  describe "delete fd_feed" do
    setup [:create_fd_feed]

    test "deletes chosen fd_feed", %{conn: conn, fd_feed: fd_feed} do
      conn = delete(conn, Routes.fd_feed_path(conn, :delete, fd_feed))
      assert redirected_to(conn) == Routes.fd_feed_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.fd_feed_path(conn, :show, fd_feed))
      end
    end
  end

  defp create_fd_feed(_) do
    fd_feed = fixture(:fd_feed)
    {:ok, fd_feed: fd_feed}
  end
end
