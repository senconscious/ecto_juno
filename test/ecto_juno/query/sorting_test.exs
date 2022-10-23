defmodule EctoJuno.Query.SortingTest do
  use ExUnit.Case, async: true

  alias EctoJuno.Fixtures.UserFixture, as: Fixtures
  alias EctoJuno.Query.Sorting
  alias EctoJuno.Repo
  alias EctoJuno.Schemas.User

  doctest EctoJuno.Query.Sorting

  @moduletag :query_sorting

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    # Setting the shared mode must be done only after checkout
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})

    user1 = Fixtures.user_fixture!(%{name: "name a", age: 18})
    user2 = Fixtures.user_fixture!(%{name: "name b", age: 20})
    user3 = Fixtures.user_fixture!(%{name: "name c", age: 22})

    {:ok, users: [user1, user2, user3]}
  end

  test "default sorting is by inserted_at in asc mode", %{users: users} do
    IO.inspect(users)
    # fields =
    #   User
    #   |> Sorting.sort_query(User)
    #   |> Repo.all()
    #   |> Enum.map(fn %{inserted_at: field} -> field end)

    # assert fields == Enum.sort(fields)
  end

  # test "sorting mode set to desc mode" do
  #   fields =
  #     User
  #     |> Sorting.sort_query(User, %{"sort_direction" => "desc"})
  #     |> Repo.all()
  #     |> Enum.map(fn %{inserted_at: field} -> field end)

  #   assert fields == Enum.sort(fields, :desc)
  # end

  # test "sorting mode set to desc mode via atom key" do
  #   fields =
  #     User
  #     |> Sorting.sort_query(User, %{sort_direction: "desc"})
  #     |> Repo.all()
  #     |> Enum.map(fn %{inserted_at: field} -> field end)

  #   assert fields == Enum.sort(fields, :desc)
  # end

  # test "sorting mode set to desc mode via atom value" do
  #   fields =
  #     User
  #     |> Sorting.sort_query(User, %{"sort_direction" => :desc})
  #     |> Repo.all()
  #     |> Enum.map(fn %{inserted_at: field} -> field end)

  #   assert fields == Enum.sort(fields, :desc)
  # end

  # test "unknown sorting mode falls to default asc" do
  #   fields =
  #     User
  #     |> Sorting.sort_query(User, %{"sort_direction" => :unknown})
  #     |> Repo.all()
  #     |> Enum.map(fn %{inserted_at: field} -> field end)

  #   assert fields == Enum.sort(fields)
  # end

  # test "unknown sorting mode falls to option" do
  #   fields =
  #     User
  #     |> Sorting.sort_query(User, %{"sort_direction" => :unknown}, %{sort_direction: :desc})
  #     |> Repo.all()
  #     |> Enum.map(fn %{inserted_at: field} -> field end)

  #   assert fields == Enum.sort(fields, :desc)
  # end
end
