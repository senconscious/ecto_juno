defmodule EctoJuno.DataCase do
  @moduledoc """
    Test case with prepared users and posts in database
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Ecto.Adapters.SQL.Sandbox
      alias EctoJuno.Fixtures
      alias EctoJuno.Repo

      setup_all do
        :ok = Sandbox.checkout(Repo)

        Sandbox.mode(Repo, {:shared, self()})

        for {age, name, title} <- [{21, "Asuka", "x-files"}, {18, "Zimmer", "a-files"}] do
          %{id: author_id} = Fixtures.create_user!(%{age: age, name: name})
          Process.sleep(1000)
          Fixtures.create_post!(%{title: title, author_id: author_id})
        end

        :ok
      end
    end
  end
end
