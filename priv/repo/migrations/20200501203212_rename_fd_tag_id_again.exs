defmodule Phx.Repo.Migrations.RenameFdTagIdAgain do
  use Ecto.Migration

  def change do
    rename table(:fd_feed_tags), :fd_tags_id, to: :fd_tag_id
  end
end
