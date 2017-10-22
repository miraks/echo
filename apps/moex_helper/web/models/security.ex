defmodule MoexHelper.Security do
  use MoexHelper.Web, :model

  schema "securities" do
    field :code, :string
    field :next_redemption_amount, :decimal
    field :next_redemption_at, :date
    field :data, :map, default: %{}
    belongs_to :board, MoexHelper.Board
    has_many :ownerships, MoexHelper.Ownership

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:code, :next_redemption_amount, :next_redemption_at, :data, :board_id])
    |> validate_required([:code, :data, :board_id])
    |> foreign_key_constraint(:board_id)
    |> unique_constraint(:code, name: :securities_board_id_code_index)
  end

  def not_redeemed(query \\ __MODULE__) do
    from s in query,
      where: is_nil(fragment("to_date(?->>?, 'YYYY-MM-DD')", s.data, "MATDATE")) or
        fragment("to_date(?->>?, 'YYYY-MM-DD')", s.data, "MATDATE") >= ^Date.utc_today
  end
end
