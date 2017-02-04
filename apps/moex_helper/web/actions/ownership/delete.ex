defmodule MoexHelper.OwnershipAction.Delete do
  alias MoexHelper.{Repo, Ownership}

  def call(ownership) do
    ownership
    |> Ownership.changeset(%{deleted_at: NaiveDateTime.utc_now})
    |> Repo.update!
  end
end
