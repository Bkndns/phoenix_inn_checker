defmodule InnCheckerWeb.Admin.BlockControllerTest do
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
      email: "manager_test_9@server.com",
      password: "manager_9265Z3o75ds",
      is_manager: true
    }

    %User{}
      |> User.registration_changeset(user)
      |> Repo.insert!
  end

  def fixture(:history) do
    create_attrs = %{inn: 7830002293, ip: "127.0.0.1", status: true}
    {:ok, history} = InnChecker.Inn.create_history(create_attrs)
    history
  end

  setup do
    admin = admin_fixture()
    # manager = manager_fixture()
    {:ok, admin: admin}
  end



  describe "Block IP Page for Admin" do
    test "lists all blocked ip",  %{conn: conn, admin: admin} do
      # Авторизуемся для прохода в админ зону
      conn = conn
        |> InnChecker.Guardian.Plug.sign_in(admin)
        |> get(Routes.admin_block_path(conn, :index))

      assert html_response(conn, 200) =~ "Все заблокированные IP адреса"
    end
  end

  describe "Block IP show create form for Admin" do
    test "renders page with block ip form", %{conn: conn, admin: admin} do
      inn = fixture(:history)

      # Авторизуемся для прохода в админ зону
      conn = conn
        |> InnChecker.Guardian.Plug.sign_in(admin)
        |> get(Routes.admin_history_path(conn, :show, inn.id))
      assert html_response(conn, 200) =~ "Заблокировать IP"
    end
  end

  describe "Block IP for Manager" do
    test "lists all Block IP Manager view", %{conn: conn} do
      manager = manager_fixture()
      # Авторизуемся для прохода в админ зону
      conn = conn
        |> InnChecker.Guardian.Plug.sign_in(manager)
        |> get(Routes.admin_block_path(conn, :index))

      assert html_response(conn, 403) =~ "Forbidden"
    end
  end

  describe "Block IP show create form for Manager" do
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

  describe "Admin Block IP Area for user" do
    test "lists all users. User View",  %{conn: conn} do
      user = user_fixture()
      # Авторизуемся для прохода в админ зону
      conn = conn
        |> InnChecker.Guardian.Plug.sign_in(user)
        |> get(Routes.admin_block_path(conn, :index))

      assert html_response(conn, 404) =~ "Not Found"

      # assert_error_sent 404, fn ->

      # end
    end
  end

  describe "Delete Block IP" do
    test "Unblock Chosen IP", %{conn: _conn, admin: admin} do

      assert :ok == Bodyguard.permit(InnChecker.Blocker.Policy, :block_area, admin)

    end
  end

  describe "Delete Block IP - Manager" do
    test "Unblock Chosen IP - Manager", %{conn: _conn} do

      manager = manager_fixture()
      assert {:error, :unauthorized} == Bodyguard.permit(InnChecker.Blocker.Policy, :block_area, manager)

    end
  end

  describe "Delete Block IP - User" do
    test "Unblock Chosen IP - User", %{conn: _conn} do

      manager = manager_fixture()
      assert {:error, :unauthorized} == Bodyguard.permit(InnChecker.Blocker.Policy, :block_area, manager)

    end
  end


end
