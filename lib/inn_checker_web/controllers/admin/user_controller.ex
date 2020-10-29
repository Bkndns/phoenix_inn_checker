defmodule InnCheckerWeb.Admin.UserController do
  use InnCheckerWeb, :controller

  # alias InnChecker.Inn
  alias InnChecker.Users
  # alias InnChecker.Users.User
  # alias InnChecker.Repo

  action_fallback InnCheckerWeb.FallbackController

  def index(conn, _params) do
    user = conn.assigns.current_user
    users = Users.list_users()

    with :ok <- Bodyguard.permit(InnChecker.Users.Policy, :user_area, user, users) do
      render(conn, "index.html", users: users)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user
    user = Users.get_user!(id)
    with :ok <- Bodyguard.permit(InnChecker.Users.Policy, :user_area, current_user, user) do
      render(conn, "show.html", user: user)
    end
  end



end
