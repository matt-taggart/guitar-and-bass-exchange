defmodule GuitarAndBassExchange.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :brand, :string
    field :model, :string
    field :year, :integer
    field :color, :string
    field :country_built, :string
    field :number_of_strings, :integer
    field :condition, :string
    field :shipping, :boolean
    field :shipping_cost, :float
    field :price, :float

    # Add the association to the user
    belongs_to :user, GuitarAndBassExchange.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [
      :title,
      :brand,
      :model,
      :year,
      :color,
      :country_built,
      :number_of_strings,
      :condition,
      :shipping,
      :shipping_cost,
      :price,
      :user_id
    ])
    |> validate_required([
      :title,
      :brand,
      :year,
      :color,
      :country_built,
      :number_of_strings,
      :condition,
      :shipping,
      :price,
      :user_id
    ])
  end
end
