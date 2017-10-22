defmodule MoexHelper.Router do
  use MoexHelper.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :put_secure_browser_headers
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  scope "/api/private", MoexHelper.Api.Private do
    pipe_through :api

    resources "/translations", TranslationController, only: [:show], singleton: true
    resources "/session", SessionController, only: [:create], singleton: true
    resources "/current_user", CurrentUserController, only: [:show], singleton: true
    resources "/accounts", AccountController, only: [:index, :create, :update, :delete]
    scope "/securities", Securities do
      resources "/search", SearchController, only: [:show], singleton: true
    end
    scope "/ownerships", Ownerships do
      resources "/positions", PositionController, only: [:update], singleton: true
    end
    resources "/ownerships", OwnershipController, only: [:index, :create, :update, :delete]
    resources "/coupons", CouponController, only: [:index, :update]
    resources "/redemptions", RedemptionController, only: [:index, :update]
  end
end
