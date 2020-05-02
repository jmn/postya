defmodule Phx.Repo.Migrations.FdFeedFeedpostRelations do
  use Ecto.Migration

  def change do
    alter table(:fd_feedpost) do
      modify :feed_id, references(:fd_feed)
    end
  end
end
