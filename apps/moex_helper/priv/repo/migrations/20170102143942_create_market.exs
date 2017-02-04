defmodule MoexHelper.Repo.Migrations.CreateMarket do
  use Ecto.Migration

  def change do
    create table(:markets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :text, null: false
      add :engine_id, references(:engines, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:markets, [:engine_id, :name])
  end
end
