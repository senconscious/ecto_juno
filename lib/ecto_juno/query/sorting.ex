defmodule EctoJuno.Query.Sorting do
  @moduledoc """
    Module for sorting query
  """

  require Logger

  import Ecto.Query, only: [order_by: 3]

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
  @spec sort_query(Ecto.Query.t(), atom() | list(), map(), map()) :: Ecto.Query.t()
  def sort_query(query, schema_or_allowed_fields, params, opts \\ %{})

  def sort_query(query, schema, params, opts) when is_atom(schema) do
    sort_query(query, schema.__schema__(:fields), params, opts)
  end

  def sort_query(query, allowed_fields, params, opts) when is_list(allowed_fields) do
    sort_by = prepare_sort_by(allowed_fields, params, opts)
    sort_direction = prepare_sort_direction(params, opts)

    order_by(query, [], {^sort_direction, ^sort_by})
  end

  @spec prepare_sort_by(list(), map(), map()) :: atom()
  defp prepare_sort_by(allowed_fields, params, opts) do
    params
    |> extract_sort_by(opts)
    |> convert_to_atom_safely(opts)
    |> validate_sort_by_allowance(allowed_fields, opts)
  end

  @spec prepare_sort_direction(map(), map()) :: atom()
  defp prepare_sort_direction(params, opts) do
    params
    |> extract_sort_direction(opts)
    |> validate_sort_direction_allowance(opts)
  end

  defp extract_sort_by(params, opts) do
    case params do
      %{"sort_by" => field} -> field
      %{sort_by: field} -> field
      _ -> default_sort_by(opts)
    end
  end

  defp extract_sort_direction(params, opts) do
    case params do
      %{"sort_direction" => mode} -> mode
      %{sort_direction: mode} -> mode
      _ -> default_sort_direction(opts)
    end
  end

  defp validate_sort_by_allowance(field, allowed_fields, opts) when is_atom(field) do
    if field in allowed_fields do
      field
    else
      default_sort_by(opts)
    end
  end

  defp validate_sort_direction_allowance(mode, opts) when is_binary(mode) do
    case mode do
      "asc" -> :asc
      "desc" -> :desc
      _ -> default_sort_direction(opts)
    end
  end

  defp validate_sort_direction_allowance(mode, opts) when is_atom(mode) do
    if mode in [:asc, :desc] do
      mode
    else
      default_sort_direction(opts)
    end
  end

  # Returns default sort_by whether from passed `opts` or config
  @spec default_sort_by(map()) :: atom()
  defp default_sort_by(opts)

  defp default_sort_by(%{sort_by: field}), do: field

  defp default_sort_by(_opts), do: Application.fetch_env!(:ecto_juno, :sort_by)

  # Returns default sort_direction whether from passed `opts` or config
  @spec default_sort_direction(map()) :: atom()
  defp default_sort_direction(opts)

  defp default_sort_direction(%{sort_direction: mode}), do: mode

  defp default_sort_direction(_opts), do: Application.fetch_env!(:ecto_juno, :sort_direction)

  defp convert_to_atom_safely(data, opts) when is_binary(data) do
    String.to_existing_atom(data)
  rescue
    ArgumentError ->
      Logger.error("Failed to convert #{data} to existing atom")
      default_sort_by(opts)
  end

  defp convert_to_atom_safely(data, _opts) when is_atom(data), do: data
end
