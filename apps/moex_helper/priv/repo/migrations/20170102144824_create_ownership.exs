defmodule MoexHelper.Repo.Migrations.CreateOwnership do
  use Ecto.Migration

  def change do
    create table(:ownerships, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :amount, :integer, null: false
      add :price, :decimal, precision: 10, scale: 2, null: false
      add :comment, :text
      add :account_id, references(:accounts, type: :binary_id, on_delete: :delete_all)
      add :security_id, references(:securities, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end

    create index(:ownerships, :account_id)
    create index(:ownerships, :security_id)
  end
end
