defmodule Phx.Repo.Migrations.DeleteAll do
  use Ecto.Migration

  def change do
    alter table(:fd_feed) do
      add :fd_tags_id, references(:fd_tags, on_delete: :delete_all)

    end
  end
end
