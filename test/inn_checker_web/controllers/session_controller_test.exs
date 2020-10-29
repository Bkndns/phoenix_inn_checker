defmodule InnCheckerWeb.SessionControllerTest do
  use InnCheckerWeb.ConnCase

  alias InnChecker.Repo
  alias InnChecker.Users.User

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


  describe "Login Page" do
    @tag :authenticted
    test "Login Page new", %{conn: conn, admin: admin} do

      conn = conn
        |> InnChecker.Guardian.Plug.sign_in(admin)
        |> get(Routes.session_path(conn, :new))

      assert redirected_to(conn) == Routes.history_path(conn, :index)
    end
  end

  describe "Login Page Create Session" do
    @tag :authenticted
    test "Login Page Create Session", %{conn: conn} do

      conn = post(conn, Routes.session_path(conn, :create, %{"session" => %{"email" => "admin_test@server.com", "password" => "admin_31415Q"}}))

      assert redirected_to(conn) == Routes.history_path(conn, :index)
      conn = get(recycle(conn), Routes.history_path(conn, :index))
      assert html_response(conn, 200) =~ "Добро пожаловать."
    end
  end

  describe "Login Page Create Session Error" do
    @tag :authenticted
    test "Login Page Create Session Error", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create, %{"session" => %{"email" => "admt@server.com", "password" => "admi15Q"}}))
      assert html_response(conn, 200) =~ "Invalid email/password combination"
      assert html_response(conn, 200) =~ "Вход"
    end
  end

  describe "Login Page Delete Session" do
    test "Login Page Delete Session logout", %{conn: conn, admin: admin} do
      conn = conn
        |> InnChecker.Guardian.Plug.sign_in(admin)
        |> get(Routes.session_path(conn, :new))

      assert redirected_to(conn) == Routes.history_path(conn, :index)

      conn = delete(recycle(conn), Routes.session_path(conn, :delete, admin.id))

      assert redirected_to(conn) == Routes.history_path(conn, :index)
      conn = get(recycle(conn), Routes.history_path(conn, :index))
      assert html_response(conn, 200) =~ "Goodbye."
    end
  end

  describe "Login Page User" do
    @tag :authenticted
    test "Login Page if not authorized", %{conn: conn} do

      conn = get(conn, Routes.session_path(conn, :new))

      assert html_response(conn, 200) =~ "Вход"
    end
  end




end
