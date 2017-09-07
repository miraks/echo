use Mix.Config

config :quantum, cron: [
  # check_price: [
  #   schedule: "@hourly",
  #   task: {BtceWatcher.Tasks.CheckPrice, :call}
  # ],
]

import_config "prod.secret.exs"
