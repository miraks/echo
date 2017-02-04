defmodule MoexHelper.Board do
  use MoexHelper.Web, :model

  schema "boards" do
    field :name, :string
    belongs_to :market, MoexHelper.Market
    has_many :securities, MoexHelper.Security

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :market_id])
    |> validate_required([:name, :market_id])
    |> foreign_key_constraint(:market_id)
    |> unique_constraint(:name, name: :boards_market_id_name_index)
  end
end
