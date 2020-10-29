defmodule InnCheckerWeb.Admin.HistoryControllerTest do
  use InnCheckerWeb.ConnCase

  alias InnChecker.Inn
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

  @create_attrs %{inn: 7830002293, ip: "127.0.0.1", status: true}


  def fixture(:history) do
    {:ok, history} = Inn.create_history(@create_attrs)
    history
  end

  describe "Index INN" do
    @tag :authenticted
    test "lists all inn_history", %{conn: conn, admin: admin} do

      # Авторизуемся для прохода в админ зону
      conn = conn
        |> InnChecker.Guardian.Plug.sign_in(admin)
        |> get(Routes.admin_history_path(conn, :index))

      assert html_response(conn, 200) =~ "Все добавленные ИНН"
    end
  end

  describe "Index INN for User not Admin" do
    test "lists all inn_history User View", %{conn: conn} do
      user = user_fixture()
      # Авторизуемся для прохода в админ зону
      conn = conn
        |> InnChecker.Guardian.Plug.sign_in(user)
        |> get(Routes.admin_history_path(conn, :index))

      assert html_response(conn, 404) =~ "Not Found"
    end
  end

  describe "Show INN for User not Admin" do
    test "renders show inn User View", %{conn: conn} do
      inn = fixture(:history)
      user = user_fixture()
      # Авторизуемся для прохода в админ зону
      conn = conn
        |> InnChecker.Guardian.Plug.sign_in(user)
        |> get(Routes.admin_history_path(conn, :show, inn.id))

      assert html_response(conn, 404) =~ "Not Found"
    end
  end

  describe "Show INN" do
    test "renders page", %{conn: conn, admin: admin} do
      inn = fixture(:history)

      # Авторизуемся для прохода в админ зону
      conn = conn
        |> InnChecker.Guardian.Plug.sign_in(admin)
        |> get(Routes.admin_history_path(conn, :show, inn.id))
      assert html_response(conn, 200) =~ "ИНН"
      assert html_response(conn, 200) =~ "Дата добавления"
      assert html_response(conn, 200) =~ "Статус"
    end
  end

  describe "На этой странице есть форма блокировки айпи, админ должен её видеть" do
    test "renders page with block ip form", %{conn: conn, admin: admin} do
      inn = fixture(:history)

      # Авторизуемся для прохода в админ зону
      conn = conn
        |> InnChecker.Guardian.Plug.sign_in(admin)
        |> get(Routes.admin_history_path(conn, :show, inn.id))
      assert html_response(conn, 200) =~ "Заблокировать IP"
    end
  end

  describe "На этой странице есть форма блокировки айпи, менеджер не должен её видеть" do
    test "renders page with block ip form Manager Test", %{conn: conn} do
      inn = fixture(:history)
      manager = manager_fixture()


      # Авторизуемся для прохода в админ зону
      conn = conn
        |> InnChecker.Guardian.Plug.sign_in(manager)
        |> get(Routes.admin_history_path(conn, :show, inn.id))
      refute html_response(conn, 200) =~ "Заблокировать IP"
    end
  end

  describe "Delete INN" do
    setup [:create_history]

    test "deletes chosen history", %{conn: conn, history: history, admin: admin} do
      # Авторизуемся для прохода в админ зону
      conn = conn
        |> InnChecker.Guardian.Plug.sign_in(admin)
        |> delete(Routes.admin_history_path(conn, :delete, history))

      assert redirected_to(conn) == Routes.admin_history_path(conn, :index)
    end
  end


  defp create_history(_) do
    history = fixture(:history)
    %{history: history}
  end
end
