defmodule InnChecker.Inn do
  @moduledoc """
  The Inn context.
  """
  
  import Ecto.Query, warn: false
  alias InnChecker.Repo

  alias InnChecker.Inn.History

  def list_inn_history(limit \\ 50) do
    query = from(h in History, limit: ^limit, order_by: [desc: h.inserted_at] )
    Repo.all(query)
  end

  def get_history!(id), do: Repo.get!(History, id)

  def create_history(attrs \\ %{}) do
    %History{}
    |> History.changeset(attrs)
    |> Repo.insert()
  end

  def delete_history(%History{} = history) do
    Repo.delete(history)
  end

end
