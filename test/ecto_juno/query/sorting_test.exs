defmodule EctoJuno.Query.SortingTest do
  use ExUnit.Case, async: true

  import Ecto.Query, only: [join: 5, preload: 2]

  alias Ecto.Adapters.SQL.Sandbox
  alias EctoJuno.Accounts.User
  alias EctoJuno.Posts.Post
  alias EctoJuno.Query.Sorting
  alias EctoJuno.Repo

  @moduletag :sorting

  setup_all do
    :ok = Sandbox.checkout(Repo)

    for {age, name, title} <- [{21, "Asuka", "x-files"}, {18, "Zimmer", "a-files"}] do
      %{id: author_id} = create_user!(%{age: age, name: name})
      Process.sleep(1000)
      create_post!(%{title: title, author_id: author_id})
    end

    Sandbox.mode(Repo, {:shared, self()})

    :ok
  end

  describe "test data is ready" do
    test "ensure users in database" do
      data = Repo.all(User)
      assert Enum.count(data) == 2
    end

    test "ensure posts in database" do
      data = Repo.all(Post)
      assert Enum.count(data) == 2
    end
  end

  describe "sort_query/2" do
    test "OK with allowed fields as list" do
      assert [first, second] = user_default_sorting_fixture([])
      assert NaiveDateTime.compare(first, second) == :lt
    end

    test "OK with schema" do
      assert [first, second] = user_default_sorting_fixture(User)
      assert NaiveDateTime.compare(first, second) == :lt
    end
  end

  describe "sort_query/3" do
    test "default sorting" do
      assert [first, second] = user_sorting_fixture()
      assert NaiveDateTime.compare(first, second) == :lt
    end

    test "sort by valid field asc" do
      assert [first, second] =
               user_sorting_fixture(%{sort_by: "age", sort_direction: "asc"}, :age)

      assert first < second
    end

    test "sort by valid field desc" do
      assert [first, second] =
               user_sorting_fixture(%{sort_by: "age", sort_direction: "desc"}, :age)

      assert first > second
    end

    test "sort by invalid field desc" do
      assert [first, second] =
               user_sorting_fixture(%{sort_by: "invalid_field", sort_direction: "desc"})

      assert NaiveDateTime.compare(first, second) == :gt
    end

    test "sort by valid field invalid mode" do
      assert [first, second] =
               user_sorting_fixture(%{sort_by: "age", sort_direction: "invalid_mode"}, :age)

      assert first < second
    end

    test "sort by invalid field invalid mode" do
      assert [first, second] =
               user_sorting_fixture(%{sort_by: "invalid_field", sort_direction: "invalid_mode"})

      assert NaiveDateTime.compare(first, second) == :lt
    end

    test "sort by valid field desc with allowed fields as list" do
      assert [first, second] =
               user_sorting_fixture(%{sort_by: "age", sort_direction: "desc"}, :age, [
                 :age,
                 :id,
                 :name
               ])

      assert first > second
    end

    test "sort by invalid field desc with allowed fields as list" do
      assert [first, second] =
               user_sorting_fixture(%{sort_by: "age", sort_direction: "desc"}, :inserted_at, [
                 :id,
                 :name
               ])

      assert NaiveDateTime.compare(first, second) == :gt
    end
  end

  describe "sort_query/4" do
    test "default sorting" do
      [first, second] = user_sorting_by_posts_fixture()
      assert NaiveDateTime.compare(first, second) == :lt
    end

    test "sort by valid field asc" do
      [first, second] =
        user_sorting_by_posts_fixture(%{sort_by: "title", sort_direction: "asc"}, :title)

      assert first < second
    end

    test "sort by valid field desc" do
      [first, second] =
        user_sorting_by_posts_fixture(%{sort_by: "title", sort_direction: "desc"}, :title)

      assert first > second
    end

    test "sort with invalid binding falls to default sorting by base query" do
      [first, second] =
        %{}
        |> list_sorted_users_by_posts(Post, :invalid_binding)
        |> Enum.map(fn %{inserted_at: field} -> field end)

      assert NaiveDateTime.compare(first, second) == :lt
    end
  end

  defp create_user!(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert!()
  end

  defp create_post!(attrs) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert!()
  end

  defp user_sorting_fixture(
         params \\ %{},
         field \\ :inserted_at,
         schema_or_allowed_fields \\ User
       ) do
    params
    |> list_sorted_users(schema_or_allowed_fields)
    |> Enum.map(fn user -> Map.fetch!(user, field) end)
  end

  defp user_sorting_by_posts_fixture(params \\ %{}, field \\ :inserted_at) do
    params
    |> list_sorted_users_by_posts(Post, :posts)
    |> Enum.map(fn %{posts: [post]} -> Map.fetch!(post, field) end)
  end

  defp list_sorted_users(params, schema_or_allowed_fields) do
    User
    |> Sorting.sort_query(schema_or_allowed_fields, params)
    |> Repo.all()
  end

  defp list_sorted_users_by_posts(params, schema_or_allowed_fields, binding) do
    User
    |> join(:left, [u], p in assoc(u, :posts), as: :posts)
    |> preload([:posts])
    |> Sorting.sort_query(schema_or_allowed_fields, params, binding)
    |> Repo.all()
  end

  defp user_default_sorting_fixture(schema_or_allowed_fields) do
    schema_or_allowed_fields
    |> list_default_sorted_users()
    |> Enum.map(fn %{inserted_at: field} -> field end)
  end

  defp list_default_sorted_users(schema_or_allowed_fields) do
    User
    |> Sorting.sort_query(schema_or_allowed_fields)
    |> Repo.all()
  end
end
