defmodule EctoJuno.CreatePostsTable do
  use Ecto.Migration

  def change do
    create table("posts") do
      add(:author_id, references(:users), null: false)
      add(:title, :string)

      timestamps()
    end
  end
end
