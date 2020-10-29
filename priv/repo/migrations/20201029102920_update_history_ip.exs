defmodule InnChecker.Repo.Migrations.UpdateHistoryIp do
  use Ecto.Migration

  def change do
    alter table(:inn_history) do
      remove :ip, :string, default: ""
      add :ip, :string, size: 30
    end

  end
end
