defmodule FDTag do
  use Ecto.Schema

  schema "fd_tags" do
    field :name
    timestamps()
    many_to_many :fd_feed, FDFeed, join_through: FDFeedTags
  end

  def parse(tags) do
    (tags || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
  end
end
