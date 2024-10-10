defmodule GuitarAndBassExchange.Chat.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias GuitarAndBassExchange.Chat.Message

  schema "rooms" do
    field :description, :string
    field :name, :string
    has_many :messages, Message
    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
