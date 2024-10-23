defmodule GuitarAndBassExchange.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :brand, :string
      add :model, :string
      add :year, :integer
      add :color, :string
      add :country_built, :string
      add :number_of_strings, :integer
      add :condition, :string
      add :shipping, :boolean, default: false
      add :shipping_cost, :float
      add :price, :float
      add :primary_photo_id, :binary_id
      add :status, :string, default: "draft"
      add :current_step, :integer, default: 1
      add :featured, :boolean, default: false

      # Add the user_id column with a foreign key constraint
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false

      timestamps()
    end

    # Create an index for user_id for faster lookups
    create index(:posts, [:user_id])

    # Create an index for the status field
    create index(:posts, [:status])
  end
end
