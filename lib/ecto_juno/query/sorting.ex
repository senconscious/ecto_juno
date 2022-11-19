defmodule EctoJuno.Query.Sorting do
  @moduledoc """
    Module for sorting query
  """

  import Ecto.Query, only: [order_by: 3, has_named_binding?: 2]

  alias EctoJuno.Helpers.SortingParams

  @doc """
    Sorts query

    ### Parameters
    - `query`: a query you want to sort
    - `schema_or_allowed_fields`: either an ecto schema module either a list of which elements are atoms
    - `params`: a map that can have `sort_by`, `sort_direction` keys with string values

    ### Usage
    ```elixir
      alias EctoJuno.Query.Sorting

      def sort_users(sort_by, sort_direction) do
        params = %{"sort_by" => sort_by, "sort_direction" => sort_direction}

        User
        |> Sorting.sort_query(User, params)
        |> Repo.all()
      end
    ```

    You can also pass `sort_by` and `sort_direction` as atom keys:
    ```elixir
      Sorting.sort_query(query, User, %{sort_by: sort_by, sort_direction: sort_direction})
    ```

    The default sorting is by `inserted_at` field with ascending order.

    For missing sorting parameters the default values will be used.
    Same applies and for invalid sorting parameters
  """
  @spec sort_query(any(), atom() | list(), map()) :: Ecto.Query.t()
  def sort_query(query, schema_or_allowed_fields, params \\ %{}) do
    %{sort_by: sort_by, sort_direction: sort_direction} =
      SortingParams.changeset!(params, schema_or_allowed_fields)

    order_by(query, [], {^sort_direction, ^sort_by})
  end

  @doc """
    Sorts query by named joint query

    If query doesn't have provided binding than default sorting will be applied by base query

    ### Parameters
    - `query`: a query you want to sort
    - `schema_or_allowed_fields`: either an ecto schema module either a list of which elements are atoms
    - `params`: a map that can have `sort_by`, `sort_direction` keys with string values
    - `binding`: joint query name

    ### Usage
    ```elixir
      alias EctoJuno.Query.Sorting

      def sort_users_by_posts(sort_by, sort_direction) do
        params = %{"sort_by" => sort_by, "sort_direction" => sort_direction}

        User
        |> join(:left, [u], p in assoc(u, :posts), as: :posts)
        |> Sorting.sort_query(Post, params, :posts)
        |> Repo.all()
      end
    ```
  """
  @spec sort_query(any(), atom() | list(), map(), atom()) :: Ecto.Query.t()
  def sort_query(query, schema_or_allowed_fields, params, binding) do
    if has_named_binding?(query, binding) do
      %{sort_by: sort_by, sort_direction: sort_direction} =
        SortingParams.changeset!(params, schema_or_allowed_fields)

      order_by(query, [{^binding, b}], {^sort_direction, field(b, ^sort_by)})
    else
      sort_query(query, [])
    end
  end
end
