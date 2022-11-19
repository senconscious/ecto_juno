defmodule EctoJuno.Repo do
  use Ecto.Repo,
    otp_app: :ecto_juno,
    adapter: Ecto.Adapters.Postgres
end
