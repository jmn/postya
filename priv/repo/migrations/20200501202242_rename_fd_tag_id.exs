defmodule Phx.Repo.Migrations.RenameFdTagId do
  use Ecto.Migration

  def change do
    rename table(:fd_feed_tags), :fd_tag_id, to: :fd_tags_id
  end
end
