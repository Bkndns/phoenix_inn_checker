defmodule InnCheckerWeb.Admin.HistoryController do
  use InnCheckerWeb, :controller

  alias InnChecker.Inn
  # alias InnChecker.Inn.History
  # alias InnChecker.Checker.Helper

  action_fallback InnCheckerWeb.FallbackController

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, _current_user) do
    inn_history = Inn.list_inn_history()
    render(conn, "index.html", inn_history: inn_history)
  end

  def show(conn, %{"id" => id}, current_user) do
    history = Inn.get_history!(id)

    former = InnChecker.Blocker.Schema.changeset(%InnChecker.Blocker.Schema{})

    with :ok <- Bodyguard.permit(InnChecker.Inn.Policy, :show_history, current_user, history) do
      render(conn, "show.html", history: history, current_user: current_user, former: former)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    history = Inn.get_history!(id)

    with :ok <- Bodyguard.permit(InnChecker.Inn.Policy, :delete_history, current_user, history) do
      Inn.delete_history(history)
      conn
      |> put_flash(:info, "ИНН удален из базы данных.")
      |> redirect(to: Routes.admin_history_path(conn, :index))
    end

  end
end
