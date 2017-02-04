defmodule MoexHelper.Repo.Migrations.AddNameAndAmountToCoupon do
  use Ecto.Migration

  def change do
    alter table(:coupons) do
      add :name, :text, null: false
      add :amount, :decimal, precision: 10, scale: 2, null: false
    end
  end
end
