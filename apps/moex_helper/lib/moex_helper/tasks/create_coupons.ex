defmodule MoexHelper.Tasks.CreateCoupons do
  import Ecto
  import Ecto.Query

  alias MoexHelper.{Repo, Ownership, Coupon}

  @threshold_value 5
  @threshold_unit "day"

  def call do
    find_ownerships()
    |> Enum.each(&create_coupon/1)
  end

  defp find_ownerships do
    query = from o in Ownership,
      inner_join: s in assoc(o, :security),
      left_join: c in assoc(o, :coupons),
      on: c.date >= ^Date.utc_today,
      preload: [security: s],
      where:
        is_nil(o.deleted_at) and \
        is_nil(c.id) and \
        from_now(^@threshold_value, ^@threshold_unit) > fragment("to_date(?->>?, 'YYYY-MM-DD')", s.data, "NEXTCOUPON")

    Repo.all(query)
  end

  defp create_coupon(ownership) do
    ownership
    |> build_assoc(:coupons)
    |> Coupon.changeset(coupon_params(ownership))
    |> Repo.insert
  end

  defp coupon_params(ownership) do
    %{
      date: ownership.security.data["NEXTCOUPON"],
      name: ownership.security.data["SECNAME"],
      amount: ownership.amount * ownership.security.data["COUPONVALUE"]
    }
  end
end
