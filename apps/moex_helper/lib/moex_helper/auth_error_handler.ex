defmodule MoexHelper.AuthErrorHandler do
  use Phoenix.Controller

  alias MoexHelper.ErrorView

  def no_resource(conn, _params) do
    conn
    |> put_status(403)
    |> render(ErrorView, "403.json")
  end
end
