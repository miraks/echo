defmodule MoexHelper do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(MoexHelper.Repo, []),
      supervisor(MoexHelper.Endpoint, []),
      supervisor(ConCache, [[ttl_check: :timer.minutes(1), ttl: :timer.hours(1)], [name: :iss_cache]])
    ]

    opts = [strategy: :one_for_one, name: MoexHelper.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    MoexHelper.Endpoint.config_change(changed, removed)
    :ok
  end
end
