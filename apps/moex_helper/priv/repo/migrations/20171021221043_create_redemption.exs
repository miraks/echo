defmodule MoexHelper.Repo.Migrations.CreateRedemption do
  use Ecto.Migration

  def change do
    create table(:redemptions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :text, null: false
      add :amount, :decimal, precision: 10, scale: 2, null: false
      add :date, :date, null: false
      add :collected, :boolean, null: false, default: false
      add :ownership_id, references(:ownerships, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:redemptions, [:ownership_id, :date])
  end
end
