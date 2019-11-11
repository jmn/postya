defmodule Phx.UsersTest do
  use Phx.DataCase

  alias Phx.{Repo, Users, Users.User}

  @valid_params %{email: "test@example.com", password: "secret1234", confirm_password: "secret1234"}

  test "create_admin/2" do
    assert {:ok, user} = Users.create_admin(@valid_params)
    assert user.role == "admin"
  end

  test "set_admin_role/1" do
    assert {:ok, user} = Repo.insert(User.changeset(%User{}, @valid_params))
    assert user.role == "user"

    assert {:ok, user} = Users.set_admin_role(user)
    assert user.role == "admin"
  end
end
