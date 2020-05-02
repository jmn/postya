defmodule FDFeedPost do
  use Ecto.Schema

  @primary_key {:id, :integer, []}

  schema "fd_feedpost" do
    field(:title, :string)
    field(:url, :string)
    field(:author, :string)
    field(:content, :string)
    field(:date_acquired, :utc_datetime)
    field(:date_published, :utc_datetime)
    belongs_to :fd_feed, FDFeed
  end
end
