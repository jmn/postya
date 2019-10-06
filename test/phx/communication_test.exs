defmodule Phx.CommunicationTest do
  use Phx.DataCase

  alias Phx.Communication

  describe "messages" do
    alias Phx.Communication.Chat

    @valid_attrs %{message: "some message", user: "some user"}
    @update_attrs %{message: "some updated message", user: "some updated user"}
    @invalid_attrs %{message: nil, user: nil}

    def chat_fixture(attrs \\ %{}) do
      {:ok, chat} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Communication.create_chat()

      chat
    end

    test "list_messages/0 returns all messages" do
      chat = chat_fixture()
      assert Communication.list_messages() == [chat]
    end

    test "get_chat!/1 returns the chat with given id" do
      chat = chat_fixture()
      assert Communication.get_chat!(chat.id) == chat
    end

    test "create_chat/1 with valid data creates a chat" do
      assert {:ok, %Chat{} = chat} = Communication.create_chat(@valid_attrs)
      assert chat.message == "some message"
      assert chat.user == "some user"
    end

    test "create_chat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Communication.create_chat(@invalid_attrs)
    end

    test "update_chat/2 with valid data updates the chat" do
      chat = chat_fixture()
      assert {:ok, %Chat{} = chat} = Communication.update_chat(chat, @update_attrs)
      assert chat.message == "some updated message"
      assert chat.user == "some updated user"
    end

    test "update_chat/2 with invalid data returns error changeset" do
      chat = chat_fixture()
      assert {:error, %Ecto.Changeset{}} = Communication.update_chat(chat, @invalid_attrs)
      assert chat == Communication.get_chat!(chat.id)
    end

    test "delete_chat/1 deletes the chat" do
      chat = chat_fixture()
      assert {:ok, %Chat{}} = Communication.delete_chat(chat)
      assert_raise Ecto.NoResultsError, fn -> Communication.get_chat!(chat.id) end
    end

    test "change_chat/1 returns a chat changeset" do
      chat = chat_fixture()
      assert %Ecto.Changeset{} = Communication.change_chat(chat)
    end
  end
end
