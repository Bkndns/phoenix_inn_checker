defmodule InnChecker.AuthTest do
  # use InnChecker.DataCase
  use InnCheckerWeb.ConnCase

  alias InnChecker.Auth
  alias InnChecker.Repo
  alias InnChecker.Users.User

  def user_fixture() do
    user = %{
      email: "admin@server.com",
      password: "admin_31415QnoCTuT",
      is_admin: true
    }

    %User{}
      |> User.registration_changeset(user)
      |> Repo.insert!
  end

  test "login by email valid" do
    user_fixture()
    check = Auth.login_by_email(build_conn(), "admin@server.com", "admin_31415QnoCTuT")
    {status, _con} = check
    assert status == :ok
  end

  test "login by email fail" do
    user_fixture()
    check = Auth.login_by_email(build_conn(), "admin@server.com", "admin")
    {status, error, _con} = check
    assert status == :error
    assert error == :unauthorized
  end

  test "login by email not_found" do
    user_fixture()
    check = Auth.login_by_email(build_conn(), "admin1@server.com", "admin_31415QnoCTuT")
    {status, error, _con} = check
    assert status == :error
    assert error == :not_found
  end

  test "login by email empty data" do
    user_fixture()
    check = Auth.login_by_email(build_conn(), "", "")
    {status, error, _con} = check
    assert status == :error
    assert error == :not_found
  end

end
