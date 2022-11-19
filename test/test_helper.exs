ExUnit.start()

alias EctoJuno.Repo

Application.put_env(
  :ecto_juno,
  Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL", "ecto://postgres:postgres@127.0.0.1:5432/ecto_juno_test"),
  pool: Ecto.Adapters.SQL.Sandbox,
  log: false
)

{:ok, _} = Ecto.Adapters.Postgres.ensure_all_started(Repo, :temporary)

_ = Ecto.Adapters.Postgres.storage_down(Repo.config())
:ok = Ecto.Adapters.Postgres.storage_up(Repo.config())

{:ok, _pid} = Repo.start_link()

Code.require_file("create_users_table.exs", __DIR__)
Code.require_file("create_posts_table.exs", __DIR__)

:ok = Ecto.Migrator.up(Repo, 0, EctoJuno.CreateUsersTable, log: false)
:ok = Ecto.Migrator.up(Repo, 1, EctoJuno.CreatePostsTable, log: false)
Ecto.Adapters.SQL.Sandbox.mode(Repo, :manual)
Process.flag(:trap_exit, true)
