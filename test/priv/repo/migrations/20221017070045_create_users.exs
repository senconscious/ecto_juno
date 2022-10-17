defmodule EctoJuno.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :age, :integer
      add :external_id, :uuid

      timestamps()
    end
  end
end
