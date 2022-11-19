defmodule EctoJuno.Posts.Post do
  @moduledoc """
    Sample schema for tests
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias EctoJuno.Accounts.User

  schema "posts" do
    belongs_to :author, User

    field :title, :string

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:author_id, :title])
    |> validate_required([:author_id, :title])
    |> foreign_key_constraint(:author_id)
  end
end
