defmodule GuitarAndBassExchange.Repo.Migrations.CreateCheckouts do
  use Ecto.Migration

  def change do
    create table(:checkouts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :featured, :boolean, default: false
      add :promotion_amount, :float
      add :payment_intent_id, :string
      add :payment_status, :string
      add :published_at, :utc_datetime
      add :post_id, references(:posts, type: :binary_id, on_delete: :restrict)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:checkouts, [:post_id])
    create unique_index(:checkouts, [:payment_intent_id])
  end
end

