defmodule MoexHelper.Api.Private.CouponView do
  use MoexHelper.Web, :view

  def render("index.json", %{coupons: coupons}) do
    %{coupons: render_many(coupons, __MODULE__, "coupon.json")}
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
end
