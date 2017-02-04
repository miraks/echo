defmodule MoexHelper.Repo.Migrations.AddDeletedAtToOwnership do
  use Ecto.Migration

  def change do
    alter table(:ownerships) do
      add :deleted_at, :naive_datetime
    end
  end
end
