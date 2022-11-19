defmodule EctoJuno.Fixtures do
  @moduledoc """
    Fixtures
  """

  import Ecto.Query, only: [join: 5, preload: 2]

  alias EctoJuno.Accounts.User
  alias EctoJuno.Posts.Post
  alias EctoJuno.Query.Sorting
  alias EctoJuno.Repo
  alias EctoJuno.UserSorting

  def list_users, do: Repo.all(User)

  def list_posts, do: Repo.all(Post)

  def create_user!(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert!()
  end

  def create_post!(attrs) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert!()
  end

  def user_sorting_fixture(
         params \\ %{},
         field \\ :inserted_at,
         schema_or_allowed_fields \\ User
       ) do
    params
    |> list_sorted_users(schema_or_allowed_fields)
    |> Enum.map(fn user -> Map.fetch!(user, field) end)
  end

  def user_sorting_by_posts_fixture(params \\ %{}, field \\ :inserted_at) do
    params
    |> list_sorted_users_by_posts(Post, :posts)
    |> Enum.map(fn %{posts: [post]} -> Map.fetch!(post, field) end)
  end

  def list_sorted_users(params, schema_or_allowed_fields) do
    User
    |> Sorting.sort_query(schema_or_allowed_fields, params)
    |> Repo.all()
  end

  def list_sorted_users_by_posts(params, schema_or_allowed_fields, binding) do
    User
    |> join(:left, [u], p in assoc(u, :posts), as: :posts)
    |> preload([:posts])
    |> Sorting.sort_query(schema_or_allowed_fields, params, binding)
    |> Repo.all()
  end

  def user_default_sorting_fixture(schema_or_allowed_fields) do
    schema_or_allowed_fields
    |> list_default_sorted_users()
    |> Enum.map(fn %{inserted_at: field} -> field end)
  end

  def list_default_sorted_users(schema_or_allowed_fields) do
    User
    |> Sorting.sort_query(schema_or_allowed_fields)
    |> Repo.all()
  end

  def list_custom_sorted_users(params) do
    User
    |> join(:left, [u], p in assoc(u, :posts), as: :posts)
    |> preload([:posts])
    |> UserSorting.sort_query(params)
    |> Repo.all()
  end
end
