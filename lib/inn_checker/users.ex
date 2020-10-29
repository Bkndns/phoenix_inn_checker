defmodule InnChecker.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias InnChecker.Repo
  alias InnChecker.Users.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

end
