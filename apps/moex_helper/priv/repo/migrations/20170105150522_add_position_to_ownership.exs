defmodule MoexHelper.Repo.Migrations.AddPositionToOwnership do
  use Ecto.Migration

  def change do
    alter table(:ownerships) do
      add :position, :integer, null: false, default: 0
    end
  end
end
