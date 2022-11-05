defmodule EctoJuno.Helpers.SortingHelpers do
  @moduledoc """
    Sorting helpers
  """

  @doc """
    Returns atom representation of string from either list of atoms or `Ecto.Schema`

    If not found returns `nil`
  """
  @spec map_string_field_to_atom(String.t(), atom() | list()) :: atom() | nil
  def map_string_field_to_atom(string_field, schema_or_list)

  def map_string_field_to_atom(string_field, schema) when is_atom(schema) do
    map_string_field_to_atom(string_field, schema.__schema__(:fields))
  end

  def map_string_field_to_atom(string_field, list) when is_list(list) do
    Enum.find(list, fn atom_field -> Atom.to_string(atom_field) == string_field end)
  end
end
