defmodule WexWatcher.Mixfile do
  use Mix.Project

  def project do
    [
      app: :wex_watcher,
      version: "0.4.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.6",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {WexWatcher, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:poison, "~> 3.1"},
      {:httpoison, "~> 0.13.0"},
      {:quantum, "~> 2.1"}
    ]
  end
end
