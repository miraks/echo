defmodule Echo.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  defp deps do
    [
      {:distillery, "~> 1.1", runtime: false},
      {:credo, "~> 0.6.1", only: [:dev, :test], runtime: false}
    ]
  end
end
