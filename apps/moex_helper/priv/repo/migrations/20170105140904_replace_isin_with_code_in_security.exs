defmodule MoexHelper.Repo.Migrations.ReplaceIsinWithCodeInSecurity do
  use Ecto.Migration

  def up do
    drop unique_index(:securities, [:board_id, :isin])

    alter table(:securities) do
      remove :isin
      add :code, :text, null: false
    end

    create unique_index(:securities, [:board_id, :code])
  end

  def down do
    drop unique_index(:securities, [:board_id, :code])

    alter table(:securities) do
      remove :code
      add :isin, :text, null: false
    end

    create unique_index(:securities, [:board_id, :isin])
  end
end
