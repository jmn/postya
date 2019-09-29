defmodule Phx.Repo.Migrations.CreateFdFeedposts do
  use Ecto.Migration

  def change do
    create table(:fd_feedpost) do
      add :title, :string
      add :url, :string
      add :author, :string
      add :content, :text
      add :date_acquired, :utc_datetime
      add :date_published, :utc_datetime
      add :feed_id, :integer
    end
    create unique_index(:fd_feedpost, [:url])

  end
end
