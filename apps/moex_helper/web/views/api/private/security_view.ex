defmodule MoexHelper.Api.Private.SecurityView do
  use MoexHelper.Web, :view

  def render("security.json", %{security: security}) do
    %{
      id: security.id,
      code: security.code,
      data: security.data
    }
  end
end
