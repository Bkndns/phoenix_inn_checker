# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     InnChecker.Repo.insert!(%InnChecker.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias InnChecker.Repo
alias InnChecker.Users
alias InnChecker.Users.User

map_params = [
  %{
    email: "admin@server.com",
    password: "admin_31415QnoCTuT",
    is_admin: true
  },
  %{
    email: "manager@server.com",
    password: "manager_9265Z3o75ds",
    is_manager: true
  }
  %{
    email: "user@server.com",
    password: "user_33g7b531cs",
  }
]

Enum.map(map_params, fn x ->
  %User{}
  |> User.registration_changeset(x)
  |> Repo.insert!
end)
