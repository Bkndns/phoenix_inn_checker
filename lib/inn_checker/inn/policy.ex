defmodule InnChecker.Inn.Policy do
  @behaviour Bodyguard.Policy

  def authorize(:show_ip, user, _history), do: user.is_admin

  def authorize(_, user, _history) do
    cond do
      user.is_admin == true -> :ok
      user.is_manager == true -> :ok
      true -> :error
    end
  end

end
