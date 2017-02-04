defmodule MoexHelper.Repo.Migrations.AddDataToSecurity do
  use Ecto.Migration

  def change do
    alter table(:securities) do
      add :data, :map, null: false, default: "{}"
    end
  end
end
