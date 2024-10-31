defmodule GuitarAndBassExchange.Checkout do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checkouts" do
    field :featured, :boolean, default: false
    field :promotion_amount, :float
    field :payment_intent_id, :string
    field :payment_status, :string
    field :published_at, :utc_datetime
    belongs_to :post, GuitarAndBassExchange.Post

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(checkout, attrs) do
    checkout
    |> cast(attrs, [
      :featured,
      :promotion_amount,
      :payment_intent_id,
      :payment_status,
      :published_at
    ])
    |> validate_required([
      :featured,
      :promotion_amount,
      :payment_intent_id,
      :payment_status,
      :published_at
    ])
    |> foreign_key_constraint(:post_id)
  end
end
