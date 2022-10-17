defmodule EctoJuno.Repo do
  @moduledoc """
    Test repo
  """

  use Ecto.Repo,
    otp_app: :ecto_juno,
    adapter: Ecto.Adapters.Postgres
end
