defmodule EctoJuno.UserSortingTest do
  use EctoJuno.DataCase

  alias EctoJuno.Fixtures

  @moduletag :user_sorting

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
    test "default sorting" do
      [first, second] =
        %{}
        |> Fixtures.list_custom_sorted_users()
        |> Enum.map(fn %{inserted_at: field} -> field end)

      assert NaiveDateTime.compare(first, second) == :lt
    end

    test "sorting by user age asc" do
      [first, second] =
        %{sort_by: "age", sort_direction: "asc"}
        |> Fixtures.list_custom_sorted_users()
        |> Enum.map(fn %{age: field} -> field end)

      assert first < second
    end

    test "sorting by user age desc" do
      [first, second] =
        %{sort_by: "age", sort_direction: "desc"}
        |> Fixtures.list_custom_sorted_users()
        |> Enum.map(fn %{age: field} -> field end)

      assert first > second
    end

    test "sorting by post title asc" do
      [first, second] =
        %{sort_by: "post_title", sort_direction: "asc"}
        |> Fixtures.list_custom_sorted_users()
        |> Enum.map(fn %{posts: [%{title: field}]} -> field end)

      assert first < second
    end

    test "sorting by post title desc" do
      [first, second] =
        %{sort_by: "post_title", sort_direction: "desc"}
        |> Fixtures.list_custom_sorted_users()
        |> Enum.map(fn %{posts: [%{title: field}]} -> field end)

      assert first > second
    end
  end
end
