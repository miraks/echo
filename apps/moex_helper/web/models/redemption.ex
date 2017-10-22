defmodule MoexHelper.Redemption do
  use MoexHelper.Web, :model

  schema "redemptions" do
    field :date, :date
    field :name, :string
    field :amount, :decimal
    field :collected, :boolean, default: false
    belongs_to :ownership, MoexHelper.Ownership

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:date, :name, :amount, :collected, :ownership_id])
    |> validate_required([:date, :name, :amount, :collected, :ownership_id])
    |> foreign_key_constraint(:ownership_id)
    |> unique_constraint(:date, name: :markets_ownership_id_date_index)
  end
end
