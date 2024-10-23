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
      add :description, :text
      add :shipping, :boolean, default: false
      add :shipping_cost, :float
      add :price, :float
      add :status, :string, default: "draft"
      add :current_step, :integer, default: 1
      add :featured, :boolean, default: false
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:posts, [:user_id])
    create index(:posts, [:status])
  end
end
