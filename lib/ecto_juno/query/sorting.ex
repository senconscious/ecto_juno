defmodule EctoJuno.Query.Sorting do
  @moduledoc """
    Module for sorting query
  """

  import Ecto.Query, only: [order_by: 3]

  alias EctoJuno.Helpers.SortingHelpers, as: Helpers

  @doc """
    Sorts query

    ### Parameters
    - `query`: the query you want to sort
    - `schema_or_allowed_fields`: must either be the model's Ecto.Schema either list of atom keys
    - `params`: map possibly containing sort_by/sort_direction fields. As either string either as atom keys/values
    - `opts`: optional map, containing sort_by/sort_direction atom keys

    ### Sort parameters flow
    Sort parameters have certain order of appling:
    1. Parameters from `params`
    2. If failed to extract or not valid next goes - from `opts`
    3. If not specified in `opts` than parameters from configuration will be applied
  """
  @spec sort_query(any(), atom() | list(), map(), map()) :: Ecto.Query.t()
  def sort_query(query, schema_or_allowed_fields, params \\ %{}, opts \\ %{})

  def sort_query(query, schema, params, opts) when is_atom(schema) do
    sort_query(query, schema.__schema__(:fields), params, opts)
  end

  def sort_query(query, allowed_fields, params, opts) when is_list(allowed_fields) do
    sort_by = Helpers.prepare_sort_by(allowed_fields, params, opts)
    sort_direction = Helpers.prepare_sort_direction(params, opts)

    order_by(query, [], {^sort_direction, ^sort_by})
  end
end
