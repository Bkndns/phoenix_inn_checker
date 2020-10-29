defmodule InnCheckerWeb.HistoryControllerTest do
  use InnCheckerWeb.ConnCase

  alias InnChecker.Inn

  @create_attrs %{inn: 7830002293}

  def fixture(:history) do
    {:ok, history} = Inn.create_history(@create_attrs)
    history
  end

  describe "Index add new Inn" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.history_path(conn, :index))
      assert html_response(conn, 200) =~ "Введите ИНН"
    end
  end

end
