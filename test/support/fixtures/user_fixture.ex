defmodule EctoJuno.Fixtures.UserFixture do
  @moduledoc """
    Fixtures for testing user model
  """

  alias EctoJuno.Repo
  alias EctoJuno.Schemas.User

  def valid_user_attrs do
    %{
      name: "sample name",
      age: 20,
      external_id: Ecto.UUID.generate()
    }
  end

  def user_fixture!(attrs \\ %{}) do
    valid_user_attrs()
    |> Map.merge(attrs)
    |> create_user!()
  end

  def create_user!(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert!()
  end
end
