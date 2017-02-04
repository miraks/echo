defmodule MoexHelper.Repo.Migrations.CreateSecurity do
  use Ecto.Migration

  def change do
    create table(:securities, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :isin, :text, null: false
      add :board_id, references(:boards, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:securities, [:board_id, :isin])
  end
end
