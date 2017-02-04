defmodule MoexHelper.Api.Private.TranslationController do
  use MoexHelper.Web, :controller

  alias MoexHelper.I18n

  def show(conn, _params) do
    json(conn, %{translations: I18n.translations})
  end
end
