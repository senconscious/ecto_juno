defmodule EctoJuno.Helpers.SortingHelpers do
  @moduledoc """
    Helper module for sorting module
  """

  require Logger

  @spec prepare_sort_by(list(), map(), map()) :: atom()
  def prepare_sort_by(allowed_fields, params, opts) do
    params
    |> extract_sort_by(opts)
    |> convert_to_atom_safely(opts)
    |> validate_sort_by_allowance(allowed_fields, opts)
  end

  @spec prepare_sort_direction(map(), map()) :: atom()
  def prepare_sort_direction(params, opts) do
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
