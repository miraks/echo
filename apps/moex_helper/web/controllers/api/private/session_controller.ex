defmodule MoexHelper.Api.Private.SessionController do
  use MoexHelper.Web, :controller

  alias MoexHelper.{User, ErrorView}
  alias MoexHelper.UserAction.CheckPassword
  alias MoexHelper.Api.Private.CurrentUserView

  def create(conn, %{"email" => email, "password" => password}) do
    user = Repo.get_by!(User, email: email)
    if CheckPassword.call(user, password) do
      conn
      |> Guardian.Plug.sign_in(user)
      |> render(CurrentUserView, "show.json", current_user: user)
    else
      conn
      |> put_status(400)
      |> render(ErrorView, "400.json")
    end
  end
end
