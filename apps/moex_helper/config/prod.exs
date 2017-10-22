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
  {:update_redemption_info, [
    schedule: "@hourly",
    task: {MoexHelper.Tasks.UpdateRedemptionInfo, :call, []}
  ]},
  {:create_coupons, [
    schedule: "10 6 * * *",
    task: {MoexHelper.Tasks.CreateCoupons, :call, []}
  ]},
  {:create_redemptions, [
    schedule: "10 6 * * *",
    task: {MoexHelper.Tasks.CreateRedemptions, :call, []}
  ]}
]

import_config "prod.secret.exs"
