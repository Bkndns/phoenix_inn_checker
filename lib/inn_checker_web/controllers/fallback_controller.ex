defmodule InnCheckerWeb.FallbackController do
  use InnCheckerWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:forbidden)
    |> put_view(InnCheckerWeb.ErrorView)
    |> render(:"403")
  end
end
