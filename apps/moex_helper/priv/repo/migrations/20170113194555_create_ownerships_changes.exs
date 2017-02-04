defmodule MoexHelper.Repo.Migrations.CreateOwnershipsChanges do
  use Ecto.Migration

  def change do
    create table(:ownerships_changes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :ownership_id, references(:ownerships, type: :binary_id, on_delete: :delete_all)
      add :change_id, references(:changes, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end

    create index(:ownerships_changes, [:ownership_id, :change_id])
  end
end
