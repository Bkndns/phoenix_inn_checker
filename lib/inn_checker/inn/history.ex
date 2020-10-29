defmodule InnChecker.Inn.History do
  use Ecto.Schema
  import Ecto.Changeset

  schema "inn_history" do
    field :inn, :integer, size: 12
    field :status, :boolean, default: false, null: false

    field :ip, :string, size: 15
    timestamps()
  end

  @doc false
  def changeset(history, attrs) do
    history
    |> cast(attrs, [:inn, :status, :ip])
    |> validate_required([:inn])
    # |> validate_length(:inn, min: 10)
    # |> validate_length(:inn, max: 12)
  end
end
