defmodule MoexHelper.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :text, null: false
      add :encrypted_password, :text, null: false

      timestamps()
    end

    create unique_index(:users, :email)
  end
end
