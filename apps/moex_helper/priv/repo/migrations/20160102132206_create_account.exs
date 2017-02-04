defmodule MoexHelper.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :text, null: false
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end

    create index(:accounts, :user_id)
  end
end
