defmodule MoexHelper.Account do
  use MoexHelper.Web, :model

  schema "accounts" do
    field :name, :string
    belongs_to :user, MoexHelper.User
    has_many :ownerships, MoexHelper.Ownership

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :user_id])
    |> validate_required([:name, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
