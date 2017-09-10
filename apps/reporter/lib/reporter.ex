defmodule Reporter do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Reporter.Scheduler, [])
    ]

    opts = [strategy: :one_for_one, name: Reporter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
