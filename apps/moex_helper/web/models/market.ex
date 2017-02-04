defmodule MoexHelper.Market do
  use MoexHelper.Web, :model

  schema "markets" do
    field :name, :string
    belongs_to :engine, MoexHelper.Engine
    has_many :boards, MoexHelper.Board

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :engine_id])
    |> validate_required([:name, :engine_id])
    |> foreign_key_constraint(:engine_id)
    |> unique_constraint(:name, name: :markets_engine_id_name_index)
  end
end
