defmodule MoexHelper.Endpoint do
  use Phoenix.Endpoint, otp_app: :moex_helper

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_moex_helper_key",
    signing_salt: Application.get_env(:moex_helper, __MODULE__)[:signing_salt],
    max_age: 1 * 365 * 24 * 60 * 60 # 1 year

  plug MoexHelper.Router
end
