defmodule InnChecker.Repo.Migrations.CreateHistoryIp do
  use Ecto.Migration

  def change do
    alter table(:inn_history) do
      add :ip, :string, size: 20
    end

  end
end
