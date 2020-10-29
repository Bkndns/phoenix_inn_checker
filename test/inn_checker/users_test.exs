defmodule InnChecker.UsersTest do
  use InnChecker.DataCase

  alias InnChecker.Users
  alias InnChecker.Repo
  alias InnChecker.Users.User

  describe "users" do

    @valid_attrs %{
      email: "user@server.com",
      password: "admin",
      is_admin: true
    }

    @invalid_attrs %{}

    def user_fixture() do
      user = @valid_attrs

      %User{}
        |> User.registration_changeset(user)
        |> Repo.insert!
    end

    test "list_users/0 returns all users" do
      user_fixture()
      user = Repo.all(User)
      assert Users.list_users() == user
    end

    test "get_user!/1 returns the user with given id" do
      us_fix = user_fixture()
      user = Repo.get!(User, us_fix.id)
      assert Users.get_user!(user.id) == user
    end


  end
end
