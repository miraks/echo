defmodule Reporter.Mixfile do
  use Mix.Project

  def project do
    [
      app: :reporter,
      version: "0.3.0",
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
      mod: {Reporter, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:swoosh, "~> 0.9.1"},
      {:gen_smtp, "~> 0.12.0"},
      {:quantum, "~> 2.1"},
      {:decimal, "~> 1.4"},
      {:timex, "~> 3.1"}
    ]
  end
end
