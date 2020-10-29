defmodule InnChecker.Auth do

  alias InnChecker.Users.User
  alias InnChecker.Repo

  def login_by_email(conn, email, password) do
    user = Repo.get_by(User, email: String.downcase(email))
    # IO.inspect(user, label: "======")
    # IO.inspect(check_password(user, password), label: "_____")
    result = cond do
      user && check_password(user, password) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        Bcrypt.no_user_verify
        {:error, :not_found, conn}
    end

    result
  end

  def login(conn, user) do
    conn
    |> InnChecker.Guardian.Plug.sign_in(user)
  end

  def logout(conn) do
    InnChecker.Guardian.Plug.sign_out(conn)
  end

  defp check_password(user, password) do
    check = Bcrypt.check_pass(user, password)
    case check do
      {:ok, _user} -> true
      {:error, _problem} -> false
    end
  end

end
