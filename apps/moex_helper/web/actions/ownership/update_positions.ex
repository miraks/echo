defmodule MoexHelper.OwnershipAction.UpdatePositions do
  import Ecto
  import Ecto.Query

  alias Ecto.Multi
  alias MoexHelper.{Repo, Ownership}

  def call(user, positions) do
    user
    |> assoc(:ownerships)
    |> where([o], o.id in ^Map.keys(positions))
    |> Repo.all
    |> Enum.reduce(Multi.new, &update_position(&2, &1, positions))
    |> Repo.transaction
  end

  defp update_position(multi, ownership, positions) do
    changeset = Ownership.changeset(ownership, %{position: positions[ownership.id]})
    Multi.update(multi, :"ownership_#{ownership.id}", changeset)
  end
end
