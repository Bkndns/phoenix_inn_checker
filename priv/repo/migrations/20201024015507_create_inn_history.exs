defmodule InnChecker.Repo.Migrations.CreateInnHistory do
  use Ecto.Migration

  def change do
    create table(:inn_history) do

      add :inn, :bigint
      add :status, :boolean, default: false, null: false

      timestamps()
    end

  end
end
