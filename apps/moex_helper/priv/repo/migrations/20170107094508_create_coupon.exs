defmodule MoexHelper.Repo.Migrations.CreateCoupon do
  use Ecto.Migration

  def change do
    create table(:coupons, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :date, :date, null: false
      add :collected, :boolean, null: false, default: false
      add :ownership_id, references(:ownerships, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:coupons, [:ownership_id, :date])
  end
end
