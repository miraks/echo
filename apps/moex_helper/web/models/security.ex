defmodule MoexHelper.Security do
  use MoexHelper.Web, :model

  schema "securities" do
    field :code, :string
    field :data, :map, default: %{}
    belongs_to :board, MoexHelper.Board
    has_many :ownerships, MoexHelper.Ownership

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:code, :data, :board_id])
    |> validate_required([:code, :data, :board_id])
    |> foreign_key_constraint(:board_id)
    |> unique_constraint(:code, name: :securities_board_id_code_index)
  end
end
