defmodule WexWatcher do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(WexWatcher.Scheduler, [])
    ]

    opts = [strategy: :one_for_one, name: WexWatcher.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
