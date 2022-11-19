defmodule EctoJuno.UserSorting do
  @moduledoc """
    Sample custom sorting
  """

  use EctoJuno.Query.SortingTemplate

  alias EctoJuno.Accounts.User
  alias EctoJuno.Posts.Post

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
