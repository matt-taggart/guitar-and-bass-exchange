defmodule GuitarAndBassExchange.Photo.Query do
  import Ecto.Query, warn: false
  alias GuitarAndBassExchange.Repo
  alias GuitarAndBassExchange.Photo
  require Logger

  def list_photos_for_post(post_id) do
    Photo
    |> where([p], p.post_id == ^post_id)
    |> preload(:post)
    |> Repo.all()
  end

  def create_photo(attrs \\ %{}) do
    %Photo{}
    |> Photo.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, photo} -> {:ok, Repo.preload(photo, :post)}
      error -> error
    end
  end
end
