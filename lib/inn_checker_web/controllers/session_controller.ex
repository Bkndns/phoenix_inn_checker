defmodule InnCheckerWeb.SessionController do
  use InnCheckerWeb, :controller

  # alias InnChecker.Users.User
  # alias InnChecker.Repo
  alias InnChecker.Auth


  def new(conn, _) do
    if conn.assigns.current_user == nil do
      render(conn, "new.html")
    else
      redirect(conn, to: Routes.history_path(conn, :index))
    end
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    result = Auth.login_by_email(conn, email, password)

    case result do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Добро пожаловать.")
        |> redirect(to: Routes.history_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Auth.logout()
    |> put_flash(:info, "Goodbye.")
    |> redirect(to: Routes.history_path(conn, :index))
  end

end
