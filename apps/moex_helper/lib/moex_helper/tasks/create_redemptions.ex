defmodule MoexHelper.Tasks.CreateRedemptions do
  import Ecto
  import Ecto.Query

  alias Decimal, as: D
  alias MoexHelper.{Repo, Ownership, Redemption}

  @threshold_value 5
  @threshold_unit "day"

  def call do
    find_ownerships()
    |> Enum.each(&create_redemption/1)
  end

  defp find_ownerships do
    query = from o in Ownership,
      inner_join: s in assoc(o, :security),
      left_join: r in assoc(o, :redemptions),
      on: r.date >= ^Date.utc_today,
      preload: [security: s],
      where:
        is_nil(o.deleted_at) and \
        is_nil(r.id) and \
        from_now(^@threshold_value, ^@threshold_unit) > s.next_redemption_at

    Repo.all(query)
  end

  defp create_redemption(ownership) do
    ownership
    |> build_assoc(:redemptions)
    |> Redemption.changeset(redemption_params(ownership))
    |> Repo.insert
  end

  defp redemption_params(ownership) do
    %{
      name: ownership.security.data["SECNAME"],
      amount: redemption_amount(ownership),
      date: ownership.security.next_redemption_at
    }
  end

  defp redemption_amount(ownership) do
    D.mult(
      D.mult(D.new(ownership.amount), ownership.security.next_redemption_amount),
      D.new(ownership.security.data["LOTSIZE"])
    )
  end
end
