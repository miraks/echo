defmodule BtceWatcher.Mixfile do
  use Mix.Project

  def project do
    [
      app: :btce_watcher,
      version: "0.1.5",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {BtceWatcher, []},
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
