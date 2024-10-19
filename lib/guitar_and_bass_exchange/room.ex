defmodule GuitarAndBassExchange.Chat.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias GuitarAndBassExchange.Chat.Message

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "rooms" do
    field :description, :string
    field :name, :string

    has_many :messages, Message,
      foreign_key: :room_id,
      on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
