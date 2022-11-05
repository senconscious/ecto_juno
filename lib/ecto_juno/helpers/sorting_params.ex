defmodule EctoJuno.Helpers.SortingParams do
  @moduledoc """
    Validator module for sorting parameters
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias EctoJuno.Helpers.SortingHelpers, as: Helpers

  @default_sort_by Application.compile_env(:ecto_juno, :sort_by, :inserted_at)
  @default_sort_direction Application.compile_env(:ecto_juno, :sort_direction, :asc)

  @primary_key false
  embedded_schema do
    field :sort_by, :string, skip_default_validation: true
    field :sort_direction, :string, skip_default_validation: true
  end

  @doc """
    Validation function. Relies on `Ecto.Changeset`. In the end invokes `apply_action!/2`. But it should never raise
  """
  @spec changeset!(map(), atom() | list()) :: map()
  def changeset!(attrs, schema_or_list) do
    %__MODULE__{}
    |> cast(attrs, [:sort_by, :sort_direction])
    |> atomize_sort_by(schema_or_list)
    |> atomize_sort_direction()
    |> apply_action!(:insert)
  end

  defp atomize_sort_by(%{changes: %{sort_by: sort_by}} = changeset, schema_or_list)
       when is_binary(sort_by) do
    field =
      sort_by
      |> Helpers.map_string_field_to_atom(schema_or_list)
      |> traverse_nil_value(@default_sort_by)

    put_change(changeset, :sort_by, field)
  end

  defp atomize_sort_by(changeset, _schema_or_list),
    do: put_change(changeset, :sort_by, @default_sort_by)

  defp atomize_sort_direction(%{changes: %{sort_direction: direction}} = changeset) do
    sort_direction =
      direction
      |> Helpers.map_string_field_to_atom([:desc, :asc])
      |> traverse_nil_value(@default_sort_direction)

    put_change(changeset, :sort_direction, sort_direction)
  end

  defp atomize_sort_direction(changeset),
    do: put_change(changeset, :sort_direction, @default_sort_direction)

  defp traverse_nil_value(nil, default), do: default

  defp traverse_nil_value(field, _default), do: field
end
