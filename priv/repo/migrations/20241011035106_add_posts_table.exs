defmodule GuitarAndBassExchange.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :brand, :string
      add :model, :string
      add :year, :integer
      add :color, :string
      add :country_built, :string
      add :number_of_strings, :integer
      add :condition, :string
      add :shipping, :boolean
      add :shipping_cost, :float
      add :price, :float

      # Add the user_id column with a foreign key constraint
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    # Create an index for user_id for faster lookups
    create index(:posts, [:user_id])
  end
end
