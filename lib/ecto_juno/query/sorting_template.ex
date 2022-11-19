defmodule EctoJuno.Query.SortingTemplate do
  @moduledoc """
    Behaviour for sorting by implementing which you can specify sorting parameters based on provided `sort_by` field

    Define your sorting module with `prepare_sorting_params/1` callback:
    ```elixir
      defmodule Sample.UserSorting do
        use EctoJuno.Query.SortingTemplate

        def prepare_sorting_params("post_" <> field) do
          {Post, field, :posts}
        end

        def prepare_sorting_params(nil) do
          {User, "inserted_at"}
        end

        def prepare_sorting_params(field) do
          {User, field}
        end
      end
    ```
  """

  @type ecto_schema :: atom()
  @type allowed_fields :: list({atom(), atom()})
  @type ecto_schema_or_allowed_fields :: ecto_schema() | allowed_fields()
  @type sort_field :: String.t()
  @type ecto_query_binding :: atom()

  @doc """
    Traverses `sort_by` into sorting parameters for `EctoJuno.Query.Sorting.sort_query/3` or `EctoJuno.Query.Sorting.sort_query/4`
  """
  @callback prepare_sorting_params(String.t() | nil) ::
              {ecto_schema_or_allowed_fields(), sort_field()}
              | {ecto_schema_or_allowed_fields(), sort_field(), ecto_query_binding()}

  defmacro __using__(_opts) do
    quote do
      @behaviour EctoJuno.Query.SortingTemplate

      alias EctoJuno.Helpers.SortingTemplateParams
      alias EctoJuno.Query.Sorting

      @doc """
        Sorts query with custom sorting params obtained from traversed `sort_by` via `prepare_sorting_params/1` field
      """
      @spec sort_query(any(), map()) :: Ecto.Query.t()
      def sort_query(query, params) do
        params
        |> SortingTemplateParams.get_sort_by()
        |> prepare_sorting_params()
        |> case do
          {ecto_schema_or_allowed_fields, field} ->
            Sorting.sort_query(
              query,
              ecto_schema_or_allowed_fields,
              SortingTemplateParams.patch_sort_by(params, field)
            )

          {ecto_schema_or_allowed_fields, field, binding} ->
            Sorting.sort_query(
              query,
              ecto_schema_or_allowed_fields,
              SortingTemplateParams.patch_sort_by(params, field),
              binding
            )
        end
      end
    end
  end
end
