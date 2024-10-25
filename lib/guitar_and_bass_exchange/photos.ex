defmodule GuitarAndBassExchange.Photo do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "photos" do
    field :url, :string

    belongs_to :post, GuitarAndBassExchange.Post

    timestamps()
  end

  @doc false
  def changeset(photo, attrs) do
    photo
    |> cast(attrs, [:url, :post_id])
    |> validate_required([:url, :post_id])
  end
end
