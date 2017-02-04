defmodule MoexHelper.Repo.Migrations.CreateEngine do
  use Ecto.Migration

  def change do
    create table(:engines, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :text, null: false

      timestamps()
    end

    create unique_index(:engines, :name)
  end
end
