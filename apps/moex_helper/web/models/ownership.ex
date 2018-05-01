defmodule MoexHelper.Ownership do
  use MoexHelper.Web, :model

  alias MoexHelper.Repo

  schema "ownerships" do
    field :amount, :integer
    field :price, :decimal
    field :comment, :string
    field :position, :integer, default: 0
    field :deleted_at, :naive_datetime
    belongs_to :account, MoexHelper.Account
    belongs_to :security, MoexHelper.Security
    has_many :coupons, MoexHelper.Coupon
    has_many :redemptions, MoexHelper.Redemption
    many_to_many :changes, MoexHelper.Change, join_through: MoexHelper.OwnershipChange

    timestamps()
  end

  def not_deleted(query \\ __MODULE__) do
    from o in query, where: is_nil(o.deleted_at)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Repo.preload(:changes)
    |> cast(params, [:amount, :price, :comment, :position, :deleted_at, :account_id, :security_id])
    |> validate_required([:amount, :price, :position, :account_id, :security_id])
    |> foreign_key_constraint(:account_id)
    |> foreign_key_constraint(:security_id)
    |> prepare_changes(&save_changes/1)
  end

  defp save_changes(changeset) do
    put_assoc(changeset, :changes, [%{data: changeset.changes} | changeset.data.changes])
  end

  def total_value(ownership) do
    security = ownership.security
    value = (security.data["FACEVALUE"] * security.data["PREVPRICE"] / 100 + security.data["ACCRUEDINT"]) * security.data["LOTSIZE"] * ownership.amount
    Float.round(value, 2)
  end
end
