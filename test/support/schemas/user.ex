defmodule EctoJuno.Schemas.User do
  @moduledoc """
    Sample schema for tests
  """
  use Ecto.Schema

  embedded_schema do
    field :age, :integer
    field :name, :string
    timestamps()
  end
end
