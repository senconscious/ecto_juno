defmodule EctoJuno.Query.SortingTest do
  use ExUnit.Case

  alias EctoJuno.Query.Sorting
  alias EctoJuno.Schemas.User

  @moduletag :sorting

  test "sort_query/3 with default params" do
    assert sorting_fixture(User) ==
             "#Ecto.Query<from s0 in \"SELECT * FROM Table\", order_by: [asc: s0.inserted_at]>"
  end

  test "sort_query/3 with default params and allowed fields list" do
    assert sorting_fixture([:inserted_at]) ==
             "#Ecto.Query<from s0 in \"SELECT * FROM Table\", order_by: [asc: s0.inserted_at]>"
  end

  test "sort_query/3 with valid params" do
    assert sorting_fixture(User, %{"sort_by" => "age", "sort_direction" => "desc"}) ==
             "#Ecto.Query<from s0 in \"SELECT * FROM Table\", order_by: [desc: s0.age]>"
  end

  test "sort_query/3 with invalid params" do
    assert sorting_fixture(User, %{
             "sort_by" => "invalid_field",
             "sort_direction" => "invalid_sorting_mode"
           }) ==
             "#Ecto.Query<from s0 in \"SELECT * FROM Table\", order_by: [asc: s0.inserted_at]>"
  end

  defp sorting_fixture(schema_or_list, params \\ %{}) do
    "SELECT * FROM Table"
    |> Sorting.sort_query(schema_or_list, params)
    |> inspect()
  end
end
