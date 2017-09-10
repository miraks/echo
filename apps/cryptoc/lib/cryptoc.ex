defmodule Cryptoc do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Cryptoc.Scheduler, [])
    ]

    opts = [strategy: :one_for_one, name: Cryptoc.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
