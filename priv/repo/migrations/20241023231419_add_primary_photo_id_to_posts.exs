defmodule GuitarAndBassExchange.Repo.Migrations.AddPrimaryPhotoIdToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :primary_photo_id, references(:photos, type: :binary_id, on_delete: :nilify_all)
    end

    create index(:posts, [:primary_photo_id])
  end
end
