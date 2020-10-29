defmodule InnChecker.Auth.GuardianErrorHandler do

  import InnCheckerWeb.Router.Helpers
  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_type, reason}, _opts) do
    conn
    |> Phoenix.Controller.put_flash(:error, "Для просмотра этой страницы необходимо войти в систему. (#{reason})")
    |> Phoenix.Controller.redirect(to: session_path(conn, :new))
  end
end
