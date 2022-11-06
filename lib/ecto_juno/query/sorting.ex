defmodule EctoJuno.Query.Sorting do
  @moduledoc """
    Module for sorting query
  """

  import Ecto.Query, only: [order_by: 3]

  alias EctoJuno.Helpers.SortingParams

  @doc """
    Sorts query

    ### Parameters
    - `query`: a query you want to sort
    - `schema_or_allowed_fields`: either an ecto schema module either a list of which elements are atoms
    - `params`: a map that can have `sort_by`, `sort_direction` keys with string values

    ### Usage
    ```elixir
    defmodule Sample.Accounts do
      alias EctoJuno.Query.Sorting
      alias Sample.Accounts.User
      alias Sample.Repo

      def sort_users(sort_by, sort_direction) do
        User
        |> Sorting.sort_query(User, %{"sort_by" => sort_by, "sort_direction" => sort_direction})
        |> Repo.all()
      end
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
end
