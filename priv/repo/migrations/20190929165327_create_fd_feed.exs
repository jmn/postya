defmodule Phx.Repo.Migrations.CreateFdFeed do
  use Ecto.Migration

  def change do
    create table(:fd_feed) do
      add :url, :string
      add :etag, :string
      add :date_parsed, :utc_datetime
      add :date_modified, :utc_datetime
    end
  end
end
