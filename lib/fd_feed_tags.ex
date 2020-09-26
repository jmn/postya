defmodule FDFeedTags do
  use Ecto.Schema

  @primary_key false
  schema "fd_feed_tags" do
    belongs_to :fd_feed, FDFeed
    belongs_to :fd_tags, FDTag, foreign_key: :fd_tag_id
    timestamps() # Added bonus, a join schema will also allow you to set timestamps
  end

end

# changeset = FDFeedTags.changeset(%FDFeedTags{}, %{feed_id: id, tag_id: id})

# def changeset(struct, params \\ %{}) do
#   struct
#   |> Ecto.Changeset.cast(params, [:fd_feed_id, :tag_id])
#   |> Ecto.Changeset.validate_required([:fd_feed_id, :tag_id])
#   # Maybe do some counter caching here!
# end
