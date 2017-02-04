defmodule MoexHelper.OwnershipChange do
  use MoexHelper.Web, :model

  schema "ownerships_changes" do
    belongs_to :ownership, MoexHelper.Ownership
    belongs_to :change, MoexHelper.Change

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:ownership_id, :change_id])
    |> validate_required([:ownership_id, :change_id])
    |> foreign_key_constraint(:ownership_id)
    |> foreign_key_constraint(:change_id)
  end
end
