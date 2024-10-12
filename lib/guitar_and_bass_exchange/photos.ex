defmodule GuitarAndBassExchange.Photo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "photos" do
    field :url, :string

    belongs_to :post, GuitarAndBassExchange.Post

    timestamps()
  end

  @doc false
  def changeset(photo, attrs) do
    photo
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end
