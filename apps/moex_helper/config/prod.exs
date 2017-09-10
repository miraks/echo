use Mix.Config

config :logger, level: :info

config :moex_helper, MoexHelper.Endpoint,
  server: true,
  version: Mix.Project.config[:version]

config :moex_helper, MoexHelper.Scheduler, jobs: [
  {:sync_securities, [
    schedule: "@hourly",
    task: {MoexHelper.Tasks.SyncSecurities, :call, []}
  ]},
  {:create_coupons, [
    schedule: "10 6 * * *",
    task: {MoexHelper.Tasks.CreateCoupons, :call, []}
  ]}
]

import_config "prod.secret.exs"
