defmodule InnChecker.Blocker.Schema do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :ip_address, :string
    field :timestamp, :string
  end

  def changeset(schema, params \\ %{}) do
    schema
    |> cast(params, [:ip_address, :timestamp])
  end

end
