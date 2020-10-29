defmodule InnChecker.InnTest do
  use InnChecker.DataCase

  alias InnChecker.Inn

  describe "inn_history" do
    alias InnChecker.Inn.History

    @valid_attrs %{inn: 4212332111, status: false, ip: "127.0.0.1"}
    @invalid_attrs %{inn: nil}

    def history_fixture(attrs \\ %{}) do
      {:ok, history} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Inn.create_history()

      history
    end

    test "list_inn_history/0 returns all inn_history" do
      history = history_fixture()
      assert Inn.list_inn_history() == [history]
    end

    test "get_history!/1 returns the history with given id" do
      history = history_fixture()
      assert Inn.get_history!(history.id) == history
    end

    test "create_history/1 with valid data creates a history" do
      assert {:ok, %History{} = history} = Inn.create_history(@valid_attrs)
      assert history.inn == 4212332111
      assert history.ip == "127.0.0.1"
      assert history.status == false
    end

    test "create_history/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inn.create_history(@invalid_attrs)
    end

    test "delete_history/1 deletes the history" do
      history = history_fixture()
      assert {:ok, %History{}} = Inn.delete_history(history)
      assert_raise Ecto.NoResultsError, fn -> Inn.get_history!(history.id) end
    end

  end
end
