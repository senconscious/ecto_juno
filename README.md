# EctoJuno
A simple query sorting library

## Installation

Add `:ecto_juno` to the list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_juno, git: "https://github.com/senconscious/ecto_juno"}
  ]
end
```

## Configuration

You can specify default sorting field and mode in your config.exs:

```elixir
  config :ecto_juno, sort_by: :id, sort_direction: :desc
```

The default sorting is by `inserted_at` field with `asc` mode

## Usage

Lets assume you have Accounts context with User schema and Repo module.
To sort users pass your query, schema module and params into `EctoJuno.Query.Sorting.sort_query/3`

```elixir
  alias EctoJuno.Query.Sorting

  def list_sorted_users(params) do
    User
    |> Sorting.sort_query(User, params)
    |> Repo.all()
  end
```

Where `params` structure is 

```elixir
  %{"sort_by" => "id", "sort_direction" => "desc"}
```

You can also pass sorting parameters keys as atoms:

```elixir
  Sorting.sort_query(query, User, %{sort_by: "id", sort_direction: "desc"})
```

Moreover, instead of the `User` schema module, you can pass a list of which elements are atoms:
```elixir
  Sorting.sort_query(query, [:id, :age, :name, :inserted_at], %{sort_by: "id", sort_direction: "desc"})
```

If you not specify any of sorting parameters, than the default ones will be used:

```elixir
  # The default sort_direction will be used
  Sorting.sort_query(query, User, %{sort_by: "id"})

  # The default sort_by will be used
  Sorting.sort_query(query, User, %{sort_direction: "desc"})

  # The default sorting which configurable will be used
  Sorting.sort_query(query, User)
```

If you'll pass invalid sorting parameters, than default sorting ones will be used for your query:
```elixir
  Sorting.sort_query(query, User, %{sort_by: "invalid_field", sort_direction: "invalid_mode"})
```
by default will sort query by `inserted_at` field with `asc` mode

Note:
- Sorting by joint query is not supported
- Sorting with modes different from asc and desc is not supported
- No custom validators for parameters supported
- If you pass sort_by and sort_direction values not as strings you'll get exception
