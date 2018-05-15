use Mix.Releases.Config,
    default_release: :default,
    default_environment: :prod

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: "config/prod.secret.cookie" |> File.read! |> String.trim_trailing |> String.to_atom
end

release :echo do
  set version: "0.5.1"
  set applications: [
    cryptoc: :permanent,
    moex_helper: :permanent,
    reporter: :permanent,
    wex_watcher: :permanent
  ]
end
