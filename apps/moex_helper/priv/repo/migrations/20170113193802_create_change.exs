defmodule MoexHelper.Repo.Migrations.CreateChange do
  use Ecto.Migration

  def change do
    create table(:changes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :data, :map, null: false, default: "{}"

      timestamps()
    end
  end
end
