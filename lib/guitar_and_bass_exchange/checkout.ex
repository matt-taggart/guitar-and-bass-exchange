# In checkout.ex
defmodule GuitarAndBassExchange.Checkout do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "checkouts" do
    field :featured, :boolean, default: false
    field :promotion_amount, :float
    field :payment_intent_id, :string
    field :payment_status, :string
    field :published_at, :utc_datetime

    belongs_to :post, GuitarAndBassExchange.Post, foreign_key: :post_id, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  def changeset(checkout, attrs) do
    checkout
    |> cast(attrs, [
      :featured,
      :promotion_amount,
      :payment_intent_id,
      :payment_status,
      :published_at,
      :post_id
    ])
    |> validate_required([
      :featured,
      :promotion_amount,
      :payment_intent_id,
      :payment_status,
      :published_at,
      :post_id
    ])
    |> foreign_key_constraint(:post_id,
      name: "checkouts_post_id_fkey",
      message: "Post does not exist"
    )
    |> unique_constraint(:post_id,
      name: "checkouts_post_id_index",
      message: "Checkout already exists for this post"
    )
    |> unique_constraint(:payment_intent_id,
      name: "checkouts_payment_intent_id_index",
      message: "Payment intent already processed"
    )
  end
end
