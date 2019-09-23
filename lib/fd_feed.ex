defmodule FDFeed do
  use Ecto.Schema
  import Ecto.Changeset
  
  @primary_key {:id, :id, autogenerate: true}

  schema "fd_feed" do
    field(:url, :string)
  end

  @doc false
  def changeset(feed, attrs) do
    feed
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end

end
