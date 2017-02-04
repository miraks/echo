defmodule MoexHelper.Api.Private.Securities.SearchController do
  use MoexHelper.Web, :controller

  alias MoexHelper.SecurityAction.Search

  plug Guardian.Plug.EnsureResource, handler: MoexHelper.AuthErrorHandler

  def show(conn, %{"query" => query}) do
    securities = Search.call(query)
    json(conn, %{securities: securities})
  end
end
