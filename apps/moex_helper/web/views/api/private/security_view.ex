defmodule MoexHelper.Api.Private.SecurityView do
  use MoexHelper.Web, :view

  def render("security.json", %{security: security}) do
    %{
      id: security.id,
      code: security.code,
      next_redemption_amount: Decimal.to_float(security.next_redemption_amount),
      next_redemption_at: security.next_redemption_at,
      data: security.data
    }
  end
end
