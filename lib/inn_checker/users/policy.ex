defmodule InnChecker.Users.Policy do
  @behaviour Bodyguard.Policy

  def authorize(:user_area, user, _history), do: user.is_admin

end
