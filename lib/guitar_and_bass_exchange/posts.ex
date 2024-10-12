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
    field :shipping, :boolean, default: false
    field :shipping_cost, :float
    field :price, :float

    # Status to track the progress of the post
    field :status, Ecto.Enum, values: [:draft, :in_progress, :completed], default: :draft

    # Association to photos
    has_many :photos, GuitarAndBassExchange.Photo, on_delete: :delete_all

    # Association to the user
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
      :status,
      :user_id
    ])
    |> validate_required([
      :user_id
    ])
    |> validate_required_for_step()
    |> cast_assoc(:photos, with: &GuitarAndBassExchange.Photo.changeset/2, required: false)
  end

  # Custom validation based on the post's status
  defp validate_required_for_step(changeset) do
    status = get_field(changeset, :status)

    required_fields =
      case status do
        :draft ->
          []

        :in_progress ->
          [
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
            :price
          ]

        :completed ->
          [
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
            :photos
          ]
      end

    changeset
    |> validate_required(required_fields)
  end
end
