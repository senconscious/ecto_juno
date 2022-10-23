defmodule EctoJuno.Schemas.User do
  @moduledoc """
    Test schema for user model
  """

  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :age, :integer
    field :external_id, Ecto.UUID

    timestamps()
  end

  def changeset(user, attrs) do
    cast(user, attrs, [:name, :age, :external_id])
  end
end
