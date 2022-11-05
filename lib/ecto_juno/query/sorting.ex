defmodule EctoJuno.Query.Sorting do
  @moduledoc """
    Module for sorting base query
  """

  import Ecto.Query, only: [order_by: 3]

  alias EctoJuno.Helpers.SortingParams

  @doc """
    Sorts query

    ### Parameters
    - `query`: the query you want to sort
    - `schema_or_allowed_fields`: must either be the model's Ecto.Schema either list of atom keys
    - `params`: map that can have `sort_by`, `sort_direction` fields with string values

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

    You can also pass `sort_by` and `sort_direction` as atom keys

    #### Invoking `sort_query/2`
    ```elixir
      Sorting.sort_query(query, User)
    ```
    In such case sorting params will be extracted from configuration if exist. If not than default sorting: ascending by `inserted_at` field will be applied
  """
  @spec sort_query(any(), atom() | list(), map()) :: Ecto.Query.t()
  def sort_query(query, schema_or_allowed_fields, params) do
    %{sort_by: sort_by, sort_direction: sort_direction} =
      SortingParams.changeset!(params, schema_or_allowed_fields)

    order_by(query, [], {^sort_direction, ^sort_by})
  end
end
