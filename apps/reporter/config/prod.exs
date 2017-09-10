use Mix.Config

config :reporter, Reporter.Scheduler, jobs: [
  {:email_stats, [
    schedule: "10 7 * * *",
    task: {Reporter.Tasks.EmailStats, :call, []}
  ]},
]

import_config "prod.secret.exs"
