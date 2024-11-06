defmodule GuitarAndBassExchange.Post.Query do
  import Ecto.Query, warn: false
  alias GuitarAndBassExchange.Repo
  alias GuitarAndBassExchange.Post
  require Logger

  def list_posts_for_user(user_id) do
    Post
    |> where([p], p.user_id == ^user_id)
    |> Repo.all()
    |> Repo.preload(:primary_photo)
  end

  def list_featured_posts() do
    Post
    |> where([p], p.featured == true)
    |> Repo.all()
    |> Repo.preload(:photos)
    |> Repo.preload(:primary_photo)
  end

  def get_draft_post_for_user(user_id, post_id) do
    Post
    |> where([p], p.user_id == ^user_id and p.status == :draft and p.id == ^post_id)
    |> order_by([p], desc: p.updated_at)
    |> limit(1)
    |> Repo.one()
    |> Repo.preload(:photos)
    |> Repo.preload(:primary_photo)
  end

  def get_post_for_user(user_id, post_id) do
    Post
    |> where([p], p.user_id == ^user_id and p.status == :completed and p.id == ^post_id)
    |> order_by([p], desc: p.updated_at)
    |> limit(1)
    |> Repo.one()
    |> Repo.preload(:photos)
    |> Repo.preload(:primary_photo)
  end

  def update_post(%Ecto.Changeset{} = changeset) do
    changeset
    |> Repo.update()
    |> case do
      {:ok, post} ->
        {:ok, Repo.preload(post, :photos)}

      {:error, changeset} ->
        Logger.error("Failed to update post. Errors: #{inspect(changeset.errors)}")
        {:error, changeset}
    end
  end

  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, post} -> {:ok, Repo.preload(post, :photos)}
      error -> error
    end
  end
end
