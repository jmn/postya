defmodule Phx.Communication.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :message, :string
    field :user, :string

    timestamps()
  end

  @doc false
  def changeset(message, params \\ %{}) do
    message
    |> cast(params, [:user, :message])
    |> validate_required([:user, :message])
  end
end
