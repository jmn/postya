defmodule Phx.Feeds do
  @moduledoc """
  The Feeds context.
  """

  import Ecto.Query, warn: false
  alias Phx.Repo

  @doc """
  Returns the list of fd_feed.

  ## Examples

      iex> list_fd_feed()
      [%FDFeed{}, ...]

  """
  def list_fd_feed do
    Repo.all(FDFeed)
  end

  @doc """
  Gets a single fd_feed.

  Raises if the Fd feed does not exist.

  ## Examples

      iex> get_fd_feed!(123)
      FDFeed{}

  """
  def get_fd_feed!(id), do: Repo.get!(FDFeed, id) |> Repo.preload(:tags)

  @doc """
  Creates a fd_feed.

  ## Examples

      iex> create_fd_feed(%{field: value})
      {:ok, %FDFeed{}}

      iex> create_fd_feed(%{field: bad_value})
      {:error, ...}

  """
  def create_fd_feed(attrs \\ %{}) do
    IO.inspect(attrs)
    %FDFeed{}
      |> FDFeed.changeset(attrs)
      |> Repo.insert()
  end

  @doc """
  Updates a fd_feed.

  ## Examples

      iex> update_fd_feed(fd_feed, %{field: new_value})
      {:ok, %FDFeed{}}

      iex> update_fd_feed(fd_feed, %{field: bad_value})
      {:error, ...}

  """
  def update_fd_feed(%FDFeed{} = fd_feed, attrs) do
    fd_feed
      |> FDFeed.changeset(attrs)
      |> Repo.update()
  end

  @doc """
  Deletes a FDFeed.

  ## Examples

      iex> delete_fd_feed(fd_feed)
      {:ok, %FDFeed{}}

      iex> delete_fd_feed(fd_feed)
      {:error, ...}

  """
  def delete_fd_feed(%FDFeed{} = fd_feed) do
    Repo.delete(fd_feed)
  end

  @doc """
  Returns a data structure for tracking fd_feed changes.

  ## Examples

      iex> change_fd_feed(fd_feed)
      %Todo{...}

  """
  def change_fd_feed(%FDFeed{} = fd_feed) do
     FDFeed.changeset(fd_feed, %{})
  end
end
