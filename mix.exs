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
      {:distillery, "~> 1.5", runtime: false},
      {:credo, "~> 0.8.6", only: [:dev, :test], runtime: false}
    ]
  end
end
