defmodule MoexHelper.Repo.Migrations.CreateBoard do
  use Ecto.Migration

  def change do
    create table(:boards, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :text, null: false
      add :market_id, references(:markets, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:boards, [:market_id, :name])
  end
end
