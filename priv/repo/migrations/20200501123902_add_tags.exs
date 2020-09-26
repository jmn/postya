defmodule Phx.Repo.Migrations.AddTags do
  use Ecto.Migration

  def change do
    alter table(:fd_feed) do
      timestamps default: "2016-01-01 00:00:01", null: false
    end

    create table(:tags) do
      add :name, :string
      timestamps()
    end

    create unique_index(:tags, [:name])

    create table(:fd_feed_tags, primary_key: false) do
      add :fd_feed_id, references(:fd_feed)
      add :tag_id, references(:tags)
    end

  end
end
