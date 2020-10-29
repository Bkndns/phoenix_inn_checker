defmodule InnCheckerWeb.CheckAdmin do
  import Plug.Conn
  # import Guardian.Plug
  use Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = Guardian.Plug.current_resource(conn)

    if current_user.is_admin || current_user.is_manager do
      conn
    else
      conn
      |> put_status(:not_found)
      |> put_view(InnCheckerWeb.ErrorView)
      |> render(:"404")
      |> halt()
    end
  end

end
