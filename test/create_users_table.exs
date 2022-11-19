defmodule EctoJuno.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table("users") do
      add(:age, :integer)
      add(:name, :string)

      timestamps()
    end
  end
end
