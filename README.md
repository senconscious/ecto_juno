# EctoJuno

A simple query sorting library

## Installation

Add `:ecto_juno` to the list of dependencies in `mix.exs`

```elixir
def deps do
  [
    {:ecto_juno, "~> 0.3.0"}
  ]
end
```

## Configuration

You can specify default sorting field and mode in your config.exs:

```elixir
  config :ecto_juno, sort_by: :id, sort_direction: :desc
```

The default sorting is by `inserted_at` field with `asc` mode

## General sorting

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

## Sorting by joint query

To apply sorting by joint query use `EctoJuno.Query.Sorting.sort_query/4` which accepts the same arguments as
`EctoJuno.Query.Sorting.sort_query/3` except new fourth argument - joint query binding name.

Let's assume that you also have a posts table that related to users table as many to one. And posts have `title` column. Than your sorting function will be something like:

```elixir
  alias EctoJuno.Query.Sorting

  def sort_users_by_posts do
    params = %{"sort_by" => "title", "sort_direction" => "desc"}

    User
    |> join(:left, [u], p in assoc(u, :posts), as: :posts)
    |> Sorting.sort_query(Post, params, :posts)
    |> Repo.all()
  end
```

If you provide binding that query doesn't have than sorting by base query in default mode will be applied

## Custom sorting

Define your custom sorting module

```elixir
      defmodule Sample.UserSorting do
        use EctoJuno.Query.SortingTemplate

          # Maybe valid sort_by key for posts query provided
          def prepare_sorting_params("post_" <> field) do
            {Post, field, :posts}
          end

          # No sort_by key case
          def prepare_sorting_params(nil) do
            {User, "inserted_at"}
          end

          # Maybe valid sort_by key for base query provided
          def prepare_sorting_params(field) do
            {User, field}
          end
      end
```

Then you can use it like

```elixir
  alias Sample.UserSorting

  query = join(User, :left, [u], p in assoc(u, :posts), as: :posts)

  # Sort users by posts title in desc mode
  query
  |> UserSorting.sort_query(%{sort_by: "post_title", sort_direction: "desc"})
  |> Repo.all()

  # Sort users by users age
  query
  |> UserSorting.sort_query(%{"sort_by" => "age", "sort_direction" => "desc"})
  |> Repo.all()
```

Passing parameters may be done with a map either with string either atom keys. But not mixed.

## Be aware of

- Sorting with modes different from asc and desc is not supported
- If you pass sort_by and sort_direction values not as strings you'll get exception

## Testing

Clone repo: `git clone https://github.com/senconscious/ecto_juno`

1. Set `DATABASE_URL` environment variable before running tests locally
2. Run `mix check`

To test with docker: `docker compose build`
1. Run: `docker compose build`
2. Run: `docker-compose run --rm ecto_juno mix check`
