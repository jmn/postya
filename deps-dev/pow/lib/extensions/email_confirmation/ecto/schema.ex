defmodule PowEmailConfirmation.Ecto.Schema do
  @moduledoc """
  Handles the e-mail confirmation schema for user.
  """

  use Pow.Extension.Ecto.Schema.Base
  alias Ecto.Changeset
  alias Pow.{Extension.Ecto.Schema, UUID}

  @doc false
  @impl true
  def validate!(_config, module) do
    Schema.require_schema_field!(module, :email, PowEmailConfirmation)
  end

  @doc false
  @impl true
  def attrs(_config) do
    [
      {:email_confirmation_token, :string},
      {:email_confirmed_at, :utc_datetime},
      {:unconfirmed_email, :string}
    ]
  end

  @doc false
  @impl true
  def indexes(_config) do
    [{:email_confirmation_token, true}]
  end

  @doc """
  Handles e-mail confirmation if e-mail is updated.

  The `:email_confirmation_token` will always be set if the struct isn't
  persisted to the database.

  For structs persisted to the database, no changes will happen if there is no
  `:email` in the params. Likewise, no changes will happen if the `:email`
  change is the same as the persisted `:unconfirmed_email` value.

  If the `:email` change is the same as the persisted `:email` value then both
  `:email_confirmation_token` and `:unconfirmed_email` will be set to nil.

  Otherwise the `:email` change will be copied over to `:unconfirmed_email` and
  the `:email` change will be reverted back to the original persisted `:email`
  value. A unique `:email_confirmation_token` will be generated.
  """
  @impl true
  @spec changeset(Changeset.t(), map(), Config.t()) :: Changeset.t()
  def changeset(%{valid?: true} = changeset, attrs, _config) do
    cond do
      built?(changeset) ->
        put_email_confirmation_token(changeset)

      email_reverted?(changeset, attrs) ->
        changeset
        |> Changeset.put_change(:email_confirmation_token, nil)
        |> Changeset.put_change(:unconfirmed_email, nil)

      email_changed?(changeset) ->
        current_email = changeset.data.email
        changed_email = Changeset.get_field(changeset, :email)

        changeset
        |> put_email_confirmation_token()
        |> set_unconfirmed_email(current_email, changed_email)

      true ->
        changeset
    end
  end
  def changeset(changeset, _attrs, _config), do: changeset

  defp built?(changeset), do: Ecto.get_meta(changeset.data, :state) == :built

  defp email_reverted?(changeset, attrs) do
    param   = Map.get(attrs, :email) || Map.get(attrs, "email")
    current = changeset.data.email

    param == current
  end

  defp email_changed?(changeset) do
    changed_email     = Changeset.get_change(changeset, :email)
    unconfirmed_email = changeset.data.unconfirmed_email

    changed_email && changed_email != unconfirmed_email
  end

  defp put_email_confirmation_token(changeset) do
    changeset
    |> Changeset.put_change(:email_confirmation_token, UUID.generate())
    |> Changeset.unique_constraint(:email_confirmation_token)
  end

  defp set_unconfirmed_email(changeset, current_email, new_email) do
    changeset
    |> Changeset.put_change(:email, current_email)
    |> Changeset.put_change(:unconfirmed_email, new_email)
    |> Changeset.prepare_changes(&validate_unique_email/1)
  end

  defp validate_unique_email(changeset) do
    opts = Keyword.take(changeset.repo_opts, [:prefix])
    unconfirmed_email = Changeset.get_change(changeset, :unconfirmed_email)
    unique_email_changeset =
      changeset
      |> Changeset.put_change(:email, unconfirmed_email)
      |> Changeset.unsafe_validate_unique(:email, changeset.repo, opts)

    case unique_email_changeset.valid? do
      true  -> changeset
      false -> unique_email_changeset
    end
  end

  @doc """
  Sets the e-mail as confirmed.

  This updates `:email_confirmed_at` and sets `:email_confirmation_token` to
  nil.

  If the struct has a `:unconfirmed_email` value, then the `:email` will be
  changed to this value, and `:unconfirmed_email` will be set to nil.
  """
  @spec confirm_email_changeset(Ecto.Schema.t() | Changeset.t()) :: Changeset.t()
  def confirm_email_changeset(%Changeset{data: %{unconfirmed_email: unconfirmed_email}} = changeset) when not is_nil(unconfirmed_email) do
    confirm_email(changeset, unconfirmed_email)
  end
  def confirm_email_changeset(%Changeset{data: %{email_confirmed_at: confirmed_at, email: email}} = changeset) when is_nil(confirmed_at) do
    confirm_email(changeset, email)
  end
  def confirm_email_changeset(%Changeset{} = changeset), do: changeset
  def confirm_email_changeset(user) do
    user
    |> Changeset.change()
    |> confirm_email_changeset()
  end

  defp confirm_email(changeset, email) do
    confirmed_at = Pow.Ecto.Schema.__timestamp_for__(changeset.data.__struct__, :email_confirmed_at)
    changes      =
      [
        email_confirmed_at: confirmed_at,
        email: email,
        unconfirmed_email: nil,
        email_confirmation_token: nil
      ]

    changeset
    |> Changeset.change(changes)
    |> Changeset.unique_constraint(:email)
  end
end
