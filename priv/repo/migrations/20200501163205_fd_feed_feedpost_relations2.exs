defmodule Phx.Repo.Migrations.FdFeedFeedpostRelations2 do
  use Ecto.Migration

  def change do
    rename table(:fd_feedpost), :feed_id, to: :fd_feed_id

  end
end
