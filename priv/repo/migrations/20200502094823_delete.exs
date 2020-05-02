defmodule Phx.Repo.Migrations.Delete do
  use Ecto.Migration

  def change do
    drop(constraint(:fd_feed_tags, :fd_feed_tags_fd_feed_id_fkey))
    drop(constraint(:fd_feed_tags, :fd_feed_tags_tag_id_fkey))

    alter table(:fd_feed_tags) do
      modify(:fd_feed_id, references(:fd_feed, on_delete: :delete_all))
      modify(:fd_tag_id, references(:fd_tags, on_delete: :delete_all), primary_key: true)
    end
  end
end
