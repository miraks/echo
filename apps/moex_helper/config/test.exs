use Mix.Config

config :moex_helper, MoexHelper.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

import_config "test.secret.exs"
