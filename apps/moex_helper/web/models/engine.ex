defmodule MoexHelper.Engine do
  use MoexHelper.Web, :model

  schema "engines" do
    field :name, :string
    has_many :markets, MoexHelper.Market

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
