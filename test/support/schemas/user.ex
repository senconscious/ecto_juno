defmodule EctoJuno.Accounts.User do
  @moduledoc """
    Sample schema for tests
  """
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field :age, :integer
    field :name, :string
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:age, :name])
    |> validate_required([:age, :name])
  end
end
