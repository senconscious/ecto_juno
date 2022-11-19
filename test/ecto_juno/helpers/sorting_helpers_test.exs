defmodule EctoJuno.Helpers.SortingHelpersTest do
  use ExUnit.Case

  alias EctoJuno.Accounts.User
  alias EctoJuno.Helpers.SortingHelpers

  @moduletag :sorting_helpers

  test "map_string_field_to_atom/2 when field in schema's fields" do
    assert SortingHelpers.map_string_field_to_atom("id", User) == :id
    assert SortingHelpers.map_string_field_to_atom("age", User) == :age
    assert SortingHelpers.map_string_field_to_atom("name", User) == :name
    assert SortingHelpers.map_string_field_to_atom("inserted_at", User) == :inserted_at
    assert SortingHelpers.map_string_field_to_atom("updated_at", User) == :updated_at
  end

  test "map_string_field_to_atom/2 when field not in schema's fields" do
    assert is_nil(SortingHelpers.map_string_field_to_atom("not_existing_field", User))
  end

  test "map_string_field_to_atom/2 when field in list of fields" do
    allowed_fields = [:id, :age, :name, :inserted_at, :updated_at]

    assert SortingHelpers.map_string_field_to_atom("id", allowed_fields) == :id
    assert SortingHelpers.map_string_field_to_atom("age", allowed_fields) == :age
    assert SortingHelpers.map_string_field_to_atom("name", allowed_fields) == :name
    assert SortingHelpers.map_string_field_to_atom("inserted_at", allowed_fields) == :inserted_at
    assert SortingHelpers.map_string_field_to_atom("updated_at", allowed_fields) == :updated_at
  end

  test "map_string_field_to_atom/2 when field isn't in list of fields" do
    allowed_fields = []
    assert is_nil(SortingHelpers.map_string_field_to_atom("id", allowed_fields))
  end
end
