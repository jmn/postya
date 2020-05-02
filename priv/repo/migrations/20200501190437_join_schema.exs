defmodule Phx.Repo.Migrations.JoinSchema do
  use Ecto.Migration

  def change do
    alter table(:fd_feed_tags) do
      timestamps default: "2016-01-01 00:00:01", null: false
    end

    rename table(:fd_feed_tags), :tag_id, to: :fd_tag_id
    rename table("tags"), to: table("fd_tags")

  end
end
