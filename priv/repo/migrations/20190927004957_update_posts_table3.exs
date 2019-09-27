defmodule Phx.Repo.Migrations.UpdatePostsTable3 do
  use Ecto.Migration

  def change do
    create index(:posts, [:slug], unique: true)
  end

end
