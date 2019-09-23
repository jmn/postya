defmodule Phx.FeedsTest do
  use Phx.DataCase

  alias Phx.Feeds

  describe "fd_feed" do
    alias Phx.Feeds.FDFeed

    @valid_attrs %{url: "some url"}
    @update_attrs %{url: "some updated url"}
    @invalid_attrs %{url: nil}

    def fd_feed_fixture(attrs \\ %{}) do
      {:ok, fd_feed} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Feeds.create_fd_feed()

      fd_feed
    end

    test "list_fd_feed/0 returns all fd_feed" do
      fd_feed = fd_feed_fixture()
      assert Feeds.list_fd_feed() == [fd_feed]
    end

    test "get_fd_feed!/1 returns the fd_feed with given id" do
      fd_feed = fd_feed_fixture()
      assert Feeds.get_fd_feed!(fd_feed.id) == fd_feed
    end

    test "create_fd_feed/1 with valid data creates a fd_feed" do
      assert {:ok, %FDFeed{} = fd_feed} = Feeds.create_fd_feed(@valid_attrs)
      assert fd_feed.url == "some url"
    end

    test "create_fd_feed/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Feeds.create_fd_feed(@invalid_attrs)
    end

    test "update_fd_feed/2 with valid data updates the fd_feed" do
      fd_feed = fd_feed_fixture()
      assert {:ok, %FDFeed{} = fd_feed} = Feeds.update_fd_feed(fd_feed, @update_attrs)
      assert fd_feed.url == "some updated url"
    end

    test "update_fd_feed/2 with invalid data returns error changeset" do
      fd_feed = fd_feed_fixture()
      assert {:error, %Ecto.Changeset{}} = Feeds.update_fd_feed(fd_feed, @invalid_attrs)
      assert fd_feed == Feeds.get_fd_feed!(fd_feed.id)
    end

    test "delete_fd_feed/1 deletes the fd_feed" do
      fd_feed = fd_feed_fixture()
      assert {:ok, %FDFeed{}} = Feeds.delete_fd_feed(fd_feed)
      assert_raise Ecto.NoResultsError, fn -> Feeds.get_fd_feed!(fd_feed.id) end
    end

    test "change_fd_feed/1 returns a fd_feed changeset" do
      fd_feed = fd_feed_fixture()
      assert %Ecto.Changeset{} = Feeds.change_fd_feed(fd_feed)
    end
  end
end
