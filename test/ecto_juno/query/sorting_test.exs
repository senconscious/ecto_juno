defmodule EctoJuno.Query.SortingTest do
  use EctoJuno.DataCase

  alias EctoJuno.Accounts.User
  alias EctoJuno.Fixtures
  alias EctoJuno.Posts.Post
  alias EctoJuno.Repo

  @moduletag :sorting

  describe "test data is ready" do
    test "ensure users in database" do
      data = Fixtures.list_users()
      assert Enum.count(data) == 2
    end

    test "ensure posts in database" do
      data = Fixtures.list_posts()
      assert Enum.count(data) == 2
    end
  end

  describe "sort_query/2" do
    test "OK with allowed fields as list" do
      assert [first, second] = Fixtures.user_default_sorting_fixture([])
      assert NaiveDateTime.compare(first, second) == :lt
    end

    test "OK with schema" do
      assert [first, second] = Fixtures.user_default_sorting_fixture(User)
      assert NaiveDateTime.compare(first, second) == :lt
    end
  end

  describe "sort_query/3" do
    test "default sorting" do
      assert [first, second] = Fixtures.user_sorting_fixture()
      assert NaiveDateTime.compare(first, second) == :lt
    end

    test "sort by valid field asc" do
      assert [first, second] =
               Fixtures.user_sorting_fixture(%{sort_by: "age", sort_direction: "asc"}, :age)

      assert first < second
    end

    test "sort by valid field desc" do
      assert [first, second] =
               Fixtures.user_sorting_fixture(%{sort_by: "age", sort_direction: "desc"}, :age)

      assert first > second
    end

    test "sort by invalid field desc" do
      assert [first, second] =
               Fixtures.user_sorting_fixture(%{sort_by: "invalid_field", sort_direction: "desc"})

      assert NaiveDateTime.compare(first, second) == :gt
    end

    test "sort by valid field invalid mode" do
      assert [first, second] =
               Fixtures.user_sorting_fixture(
                 %{sort_by: "age", sort_direction: "invalid_mode"},
                 :age
               )

      assert first < second
    end

    test "sort by invalid field invalid mode" do
      assert [first, second] =
               Fixtures.user_sorting_fixture(%{
                 sort_by: "invalid_field",
                 sort_direction: "invalid_mode"
               })

      assert NaiveDateTime.compare(first, second) == :lt
    end

    test "sort by valid field desc with allowed fields as list" do
      assert [first, second] =
               Fixtures.user_sorting_fixture(%{sort_by: "age", sort_direction: "desc"}, :age, [
                 :age,
                 :id,
                 :name
               ])

      assert first > second
    end

    test "sort by invalid field desc with allowed fields as list" do
      assert [first, second] =
               Fixtures.user_sorting_fixture(
                 %{sort_by: "age", sort_direction: "desc"},
                 :inserted_at,
                 [
                   :id,
                   :name
                 ]
               )

      assert NaiveDateTime.compare(first, second) == :gt
    end
  end

  describe "sort_query/4" do
    test "default sorting" do
      [first, second] = Fixtures.user_sorting_by_posts_fixture()
      assert NaiveDateTime.compare(first, second) == :lt
    end

    test "sort by valid field asc" do
      [first, second] =
        Fixtures.user_sorting_by_posts_fixture(%{sort_by: "title", sort_direction: "asc"}, :title)

      assert first < second
    end

    test "sort by valid field desc" do
      [first, second] =
        Fixtures.user_sorting_by_posts_fixture(
          %{sort_by: "title", sort_direction: "desc"},
          :title
        )

      assert first > second
    end

    test "sort with invalid binding falls to default sorting by base query" do
      [first, second] =
        %{}
        |> Fixtures.list_sorted_users_by_posts(Post, :invalid_binding)
        |> Enum.map(fn %{inserted_at: field} -> field end)

      assert NaiveDateTime.compare(first, second) == :lt
    end
  end
end
