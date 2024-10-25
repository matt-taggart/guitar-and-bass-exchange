defmodule GuitarAndBassExchange.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :title, :string
    field :brand, :string
    field :model, :string
    field :year, :integer
    field :color, :string
    field :country_built, :string
    field :number_of_strings, :integer
    field :condition, :string
    field :description, :string
    field :shipping, :boolean, default: false
    field :shipping_cost, :float
    field :price, :float

    field :status, Ecto.Enum,
      values: [:draft, :completed],
      default: :draft

    field :current_step, :integer, default: 1
    field :featured, :boolean, default: false

    has_many :photos, GuitarAndBassExchange.Photo,
      on_replace: :delete_if_exists,
      on_delete: :delete_all

    belongs_to :primary_photo, GuitarAndBassExchange.Photo,
      foreign_key: :primary_photo_id,
      references: :id

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
      :description,
      :shipping,
      :shipping_cost,
      :price,
      :primary_photo_id,
      :status,
      :user_id,
      :current_step,
      :featured
    ])
    |> validate_required([:user_id])
    |> validate_required_for_step()
    |> cast_assoc(:photos, with: &GuitarAndBassExchange.Photo.changeset/2)
    |> foreign_key_constraint(:primary_photo_id)
  end

  # Custom validation based on the post's status
  defp validate_required_for_step(changeset) do
    step = get_field(changeset, :current_step)

    required_fields =
      case step do
        1 ->
          base_fields = [
            :title,
            :brand,
            :model,
            :year,
            :color,
            :country_built,
            :number_of_strings,
            :condition,
            :description,
            :shipping,
            :price
          ]

          # Conditionally require :shipping_cost if :shipping is true
          if get_field(changeset, :shipping) do
            base_fields ++ [:shipping_cost]
          else
            base_fields
          end

        2 ->
          []

        _ ->
          []
      end

    changeset |> validate_required(required_fields)
  end
end
