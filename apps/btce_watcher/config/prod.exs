use Mix.Config

config :btce_watcher, BtceWatcher.Scheduler, jobs: [
  # {:check_price, [
  #   schedule: "@hourly",
  #   task: {BtceWatcher.Tasks.CheckPrice, :call, []}
  # ]}
]

import_config "prod.secret.exs"
