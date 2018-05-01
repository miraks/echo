defmodule MoexHelper.Api.Private.CouponView do
  use MoexHelper.Web, :view

  alias MoexHelper.Api.Private.AccountView

  def render("index.json", %{coupons: coupons}) do
    %{coupons: render_many(coupons, __MODULE__, "coupon_with_assocs.json")}
  end

  def render("show.json", %{coupon: coupon}) do
    %{coupon: render_one(coupon, __MODULE__, "coupon.json")}
  end

  def render("coupon.json", %{coupon: coupon}) do
    %{
      id: coupon.id,
      date: coupon.date,
      name: coupon.name,
      amount: coupon.amount,
      collected: coupon.collected
    }
  end

  def render("coupon_with_assocs.json", %{coupon: coupon}) do
    coupon
    |> render_one(__MODULE__, "coupon.json")
    |> Map.merge(%{
      account: render_one(coupon.account, AccountView, "account.json"),
    })
  end
end
