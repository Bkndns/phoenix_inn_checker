defmodule InnCheckerWeb.HistoryController do
  use InnCheckerWeb, :controller

  alias InnChecker.Inn
  # alias InnChecker.Inn.History
  # alias InnChecker.Checker.Helper

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, _current_user) do
    history_inn = Inn.list_inn_history(20)
    render(conn, "index.html", history: history_inn)
  end

  def create(conn, %{"history" => history_params}, _current_user) do
    case Inn.create_history(history_params) do
      {:ok, history} ->
        conn
        |> put_flash(:info, "ИНН успешно добавлен")
        |> redirect(to: Routes.history_path(conn, :index, history))

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_status(403)
        |> put_layout(false)
        |> render(InnCheckerWeb.ErrorView, "403.html")
    end
  end


end
