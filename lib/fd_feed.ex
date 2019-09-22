defmodule FDFeed do
  use Ecto.Schema

  @primary_key {:id, :integer, []}

  schema "fd_feed" do
    field(:url, :string)
  end
end
