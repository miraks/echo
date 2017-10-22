defmodule MoexHelper.Repo.Migrations.AddNextRedemptionAtToSecurity do
  use Ecto.Migration

  def change do
    alter table(:securities) do
      add :next_redemption_amount, :decimal, precision: 12, scale: 5
      add :next_redemption_at, :date
    end
  end
end
