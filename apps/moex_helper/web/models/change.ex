defmodule MoexHelper.Change do
  use MoexHelper.Web, :model

  schema "changes" do
    field :data, :map
    many_to_many :ownerships, MoexHelper.Ownership, join_through: MoexHelper.OwnershipChange

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:data])
    |> validate_required([:data])
  end
end
