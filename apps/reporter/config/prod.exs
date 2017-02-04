use Mix.Config

config :quantum, cron: [
  email_stats: [
    schedule: "10 7 * * *",
    task: {Reporter.Tasks.EmailStats, :call}
  ],
]

import_config "prod.secret.exs"
