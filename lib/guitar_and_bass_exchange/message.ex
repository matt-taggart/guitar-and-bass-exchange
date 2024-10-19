defmodule GuitarAndBassExchange.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias GuitarAndBassExchange.Chat.Room
  alias GuitarAndBassExchange.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "messages" do
    field :content, :string
    belongs_to :room, Room, type: :binary_id
    belongs_to :sender, User, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :sender_id, :room_id])
    |> validate_required([:content, :sender_id, :room_id])
  end
end
