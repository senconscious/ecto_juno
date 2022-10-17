defmodule EctoJuno.RepoCase do
  @moduledoc """
    Test case
  """

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox
  alias EctoJuno.{Repo, RepoCase}

  using do
    quote do
      alias Repo

      import RepoCase
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Repo)

    unless tags[:async] do
      Sandbox.mode(Repo, {:shared, self()})
    end

    :ok
  end
end
