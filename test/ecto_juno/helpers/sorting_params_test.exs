defmodule EctoJuno.Helpers.SortingParamsTest do
  use ExUnit.Case

  alias EctoJuno.Accounts.User
  alias EctoJuno.Helpers.SortingParams

  @moduletag :sorting_params

  test "changeset!/2 when valid params provided with schema" do
    assert %{sort_by: :id, sort_direction: :desc} =
             SortingParams.changeset!(%{"sort_by" => "id", "sort_direction" => "desc"}, User)
  end

  test "changeset!/2 when valid params provided with list of allowed_fields" do
    allowed_fields = [:id]

    assert %{sort_by: :id, sort_direction: :desc} =
             SortingParams.changeset!(
               %{"sort_by" => "id", "sort_direction" => "desc"},
               allowed_fields
             )
  end

  test "changeset!/2 when invalid sort_direction provided" do
    assert %{sort_by: :id, sort_direction: :asc} =
             SortingParams.changeset!(
               %{"sort_by" => "id", "sort_direction" => "unvalid_sort_direction"},
               User
             )
  end

  test "changeset!/2 when invalid sort_by provided" do
    assert %{sort_by: :inserted_at, sort_direction: :desc} =
             SortingParams.changeset!(
               %{"sort_by" => "invalid_field", "sort_direction" => "desc"},
               User
             )
  end

  test "changeset!/2 returns default sorting fields when they not provided" do
    assert %{sort_by: :inserted_at, sort_direction: :asc} = SortingParams.changeset!(%{}, User)
  end

  test "changeset!/2 returns only sort_by default field when sort_by not provided" do
    assert %{sort_by: :inserted_at, sort_direction: :desc} =
             SortingParams.changeset!(%{"sort_direction" => "desc"}, User)
  end

  test "changeset!/2 returns only sort_direction default field when sort_direction not provided" do
    assert %{sort_by: :age, sort_direction: :asc} =
             SortingParams.changeset!(%{"sort_by" => "age"}, User)
  end
end
