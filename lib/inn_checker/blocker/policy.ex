defmodule InnChecker.Blocker.Policy do
  @behaviour Bodyguard.Policy

  def authorize(:block_area, user, _history), do: user.is_admin

end
