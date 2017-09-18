use Mix.Config

config :wex_watcher, WexWatcher.Scheduler, jobs: [
  {:check_price, [
    schedule: "@hourly",
    task: {WexWatcher.Tasks.CheckPrice, :call, []}
  ]}
]

import_config "prod.secret.exs"
