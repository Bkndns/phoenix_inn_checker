defmodule InnCheckerWeb.Admin.UserControllerTest do
  use InnCheckerWeb.ConnCase

  alias InnChecker.Repo
  alias InnChecker.Users.User

  def user_fixture() do
    user = %{
      email: "user_test@server.com",
      password: "user15Q",
    }

    %User{}
      |> User.registration_changeset(user)
      |> Repo.insert!
  end

  def admin_fixture() do
    user = %{
      email: "admin_test@server.com",
      password: "admin_31415Q",
      is_admin: true
    }

    %User{}
      |> User.registration_changeset(user)
      |> Repo.insert!
  end

  def manager_fixture() do
    user = %{
      email: "manager@server.com",
      password: "manager_9265Z3o75ds",
      is_manager: true
    }

    %User{}
      |> User.registration_changeset(user)
      |> Repo.insert!
  end

  setup do
    admin = admin_fixture()
    # manager = manager_fixture()
    {:ok, admin: admin}
  end



  describe "User index for Admin" do
    test "lists all users",  %{conn: conn, admin: admin} do
      # Авторизуемся для прохода в админ зону
      conn = conn
        |> InnChecker.Guardian.Plug.sign_in(admin)
        |> get(Routes.admin_user_path(conn, :index))

      assert html_response(conn, 200) =~ "Список пользователей"
    end
  end

  describe "User show page for Admin" do
    test "look at one user",  %{conn: conn, admin: admin} do
      # Авторизуемся для прохода в админ зону
      conn = conn
        |> InnChecker.Guardian.Plug.sign_in(admin)
        |> get(Routes.admin_user_path(conn, :show, admin.id))

      assert html_response(conn, 200) =~ "admin_test@server.com"
      assert html_response(conn, 200) =~ "Admin true"
      assert html_response(conn, 200) =~ "Manager false"
    end
  end

  describe "User index for Manager" do
    test "lists all users Manager view", %{conn: conn} do
      manager = manager_fixture()
      # Авторизуемся для прохода в админ зону
      conn = conn
        |> InnChecker.Guardian.Plug.sign_in(manager)
        |> get(Routes.admin_user_path(conn, :index))

      assert html_response(conn, 403) =~ "Forbidden"
    end
  end

  describe "User show page for Manager" do
    test "look at one user Manager View",  %{conn: conn} do
      manager = manager_fixture()
      # Авторизуемся для прохода в админ зону
      conn = conn
        |> InnChecker.Guardian.Plug.sign_in(manager)
        |> get(Routes.admin_user_path(conn, :show, manager.id))

      assert html_response(conn, 403) =~ "Forbidden"
    end
  end

  describe "Admin User Area index for user" do
    test "lists all users",  %{conn: conn} do
      user = user_fixture()
      # Авторизуемся для прохода в админ зону
      conn = conn
        |> InnChecker.Guardian.Plug.sign_in(user)
        |> get(Routes.admin_user_path(conn, :index))

      assert html_response(conn, 404) =~ "Not Found"

      # assert_error_sent 404, fn ->

      # end
    end
  end

  describe "Admin User area show page for User" do
    test "look at one user User View",  %{conn: conn} do
      user = user_fixture()
      # Авторизуемся для прохода в админ зону
      conn = conn
        |> InnChecker.Guardian.Plug.sign_in(user)
        |> get(Routes.admin_user_path(conn, :index))

      assert html_response(conn, 404) =~ "Not Found"

      # assert_error_sent 404, fn ->

      # end
    end
  end


end
