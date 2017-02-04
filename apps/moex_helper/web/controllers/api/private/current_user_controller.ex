defmodule MoexHelper.Api.Private.CurrentUserController do
  use MoexHelper.Web, :controller

  def show(conn, _params) do
    current_user = current_resource(conn)
    render(conn, "show.json", current_user: current_user)
  end
end
