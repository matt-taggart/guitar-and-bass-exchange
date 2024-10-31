defmodule GuitarAndBassExchange.Repo.Migrations.CreateCheckouts do
  use Ecto.Migration

  def change do
    create table(:checkouts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :featured, :boolean, default: false, null: false
      add :promotion_amount, :float, null: false
      add :payment_method, :string, default: "stripe", null: false
      add :payment_intent_id, :string, null: false
      add :payment_status, :string, null: false
      add :status, :string, default: "pending", null: false
      add :published_at, :utc_datetime, null: false
      add :post_id, references(:posts, type: :binary_id, on_delete: :restrict), null: false
      add :user_id, references(:users, type: :binary_id, on_delete: :restrict), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:checkouts, [:post_id])
    create index(:checkouts, [:user_id])
    create index(:checkouts, [:status])
    create index(:checkouts, [:payment_status])
    create index(:checkouts, [:published_at])
    create unique_index(:checkouts, [:payment_intent_id])
    create unique_index(:checkouts, [:post_id])
  end
end
