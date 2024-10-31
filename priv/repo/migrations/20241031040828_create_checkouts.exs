defmodule GuitarAndBassExchange.Repo.Migrations.CreateCheckouts do
  use Ecto.Migration

  def change do
    create table(:checkouts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :featured, :boolean, default: false, null: false
      add :promotion_amount, :float
      add :payment_intent_id, :string
      add :payment_status, :string
      add :published_at, :utc_datetime
      add :post_id, references(:posts, type: :binary_id, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:checkouts, [:post_id])
  end
end
