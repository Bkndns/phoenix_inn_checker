defmodule InnChecker.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias InnChecker.Users.User
  # alias InnChecker.Repo

  '''
  alias InnChecker.Repo
  alias InnChecker.Users.User
  data = %{email: "denba@gmail.com", password: "95432454", is_admin: true}
  changeset = User.registration_changeset(%User{}, data)
  Repo.insert(changeset)

  '''

  schema "users" do
    field :email, :string
    field :is_admin, :boolean, default: false, null: false
    field :is_manager, :boolean, default: false, null: false
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end


  def changeset(users, attrs) do
    users
    |> cast(attrs, [:email, :is_admin, :is_manager, :password])
    |> validate_required([:email])
  end

  def registration_changeset(%User{} = users, params \\ %{}) do
    users
    |> cast(params, [:email, :password, :is_admin, :is_manager])
    |> validate_required([:email, :password])
    # |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  def put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
      _ ->
        changeset
    end
  end

end
