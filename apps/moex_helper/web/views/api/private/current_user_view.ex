defmodule MoexHelper.Api.Private.CurrentUserView do
  use MoexHelper.Web, :view

  def render("show.json", %{current_user: current_user}) do
    %{current_user: render_one(current_user, __MODULE__, "current_user.json")}
  end

  def render("current_user.json", %{current_user: current_user}) do
    %{
      id: current_user.id,
      email: current_user.email
    }
  end
end
