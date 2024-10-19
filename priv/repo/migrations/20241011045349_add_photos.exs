defmodule GuitarAndBassExchange.Repo.Migrations.AddPhotos do
  use Ecto.Migration

  def change do
    create table(:photos, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :url, :string
      add :post_id, references(:posts, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end

    create index(:photos, [:post_id])
  end
end
