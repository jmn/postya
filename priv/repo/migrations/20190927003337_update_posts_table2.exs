defmodule Phx.Repo.Migrations.UpdatePostsTable2 do
  use Ecto.Migration

  def change do
    alter table("posts") do
      add :slug, :string
    end
  end
end
