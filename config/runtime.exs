import Config

if config_env() == :test do
  database_url =
    System.get_env("DATABASE_URL") || "ecto://postgres:postgres@127.0.0.1:5432/ecto_juno_test"

  config :ecto_juno, EctoJuno.Repo,
    url: database_url
end
