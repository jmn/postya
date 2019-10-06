defmodule Phx.Communication do
  @moduledoc """
  The Communication context.
  """

  import Ecto.Query, warn: false
  alias Phx.Repo

  alias Phx.Communication.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Chat{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  @doc """
  Gets a single chat.

  Raises `Ecto.NoResultsError` if the Chat does not exist.

  ## Examples

      iex> get_chat!(123)
      %Chat{}

      iex> get_chat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chat!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a chat.

  ## Examples

      iex> create_chat(%{field: value})
      {:ok, %Chat{}}

      iex> create_chat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(message_params) do
#    c = Message.changeset(message_params)
    %Message{}
    |> Message.changeset(message_params)
    |> Repo.insert()

      Repo.all(Message)
  end

  @doc """
  Updates a chat.

  ## Examples

      iex> update_chat(chat, %{field: new_value})
      {:ok, %Chat{}}

      iex> update_chat(chat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chat(%Message{} = chat, attrs) do
    chat
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Chat.

  ## Examples

      iex> delete_chat(chat)
      {:ok, %Chat{}}

      iex> delete_chat(chat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chat changes.

  ## Examples

      iex> change_chat(chat)
      %Ecto.Changeset{source: %Chat{}}

  """
  def change_message do
    Message.changeset(%Message{})
  end

  def change_message(changeset, changes) do
    Message.changeset(changeset, changes)
  end

end
