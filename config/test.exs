import Config

config :ecto_juno, :ecto_repos, [EctoJuno.Repo]

config :ecto_juno, EctoJuno.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  priv: "./test/priv/repo"
