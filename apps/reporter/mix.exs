defmodule Reporter.Mixfile do
  use Mix.Project

  def project do
    [
      app: :reporter,
      version: "0.1.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:swoosh, "~> 0.5.0"},
      {:gen_smtp, "~> 0.11.0"},
      {:quantum, "~> 1.8"},
      {:decimal, "~> 1.3"},
      {:timex, "~> 3.1"}
    ]
  end
end
