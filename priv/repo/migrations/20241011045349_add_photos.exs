defmodule GuitarAndBassExchange.Repo.Migrations.AddPhotos do
  use Ecto.Migration

  def change do
    create table(:photos) do
      add :url, :string
      add :description, :string
      # Foreign key to posts
      add :post_id, references(:posts, on_delete: :delete_all)

      timestamps()
    end

    create index(:photos, [:post_id])
  end
end
