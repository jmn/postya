defmodule Phx.Tag do
  use Ecto.Schema

  schema "tags" do
    field :name
    timestamps()
  end

  def parse(tags) do
    (tags || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
  end
end
