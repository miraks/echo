use Mix.Config

config :moex_helper,
  ecto_repos: [MoexHelper.Repo]

config :moex_helper, MoexHelper.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: MoexHelper.ErrorView, accepts: ~w(json)]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :generators,
  binary_id: true

config :guardian, Guardian,
  allowed_algos: ["HS512"],
  issuer: "MoexHelper",
  ttl: {1, :year},
  verify_issuer: true,
  secret_key: "#{Mix.env}.secret.key" |> Path.expand(__DIR__) |> File.read!,
  serializer: MoexHelper.GuardianSerializer

import_config "#{Mix.env}.exs"
