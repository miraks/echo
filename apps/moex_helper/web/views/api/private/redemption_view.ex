defmodule MoexHelper.Api.Private.RedemptionView do
  use MoexHelper.Web, :view

  def render("index.json", %{redemptions: redemptions}) do
    %{redemptions: render_many(redemptions, __MODULE__, "redemption.json")}
  end

  def render("show.json", %{redemption: redemption}) do
    %{redemption: render_one(redemption, __MODULE__, "redemption.json")}
  end

  def render("redemption.json", %{redemption: redemption}) do
    %{
      id: redemption.id,
      date: redemption.date,
      name: redemption.name,
      amount: redemption.amount,
      collected: redemption.collected
    }
  end
end
