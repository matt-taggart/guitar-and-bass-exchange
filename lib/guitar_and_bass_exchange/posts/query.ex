defmodule GuitarAndBassExchange.Post.Query do
  import Ecto.Query, warn: false
  alias GuitarAndBassExchange.Repo
  alias GuitarAndBassExchange.Post

  def update_post(%Ecto.Changeset{} = changeset) do
    # Update the post using the changeset
    Repo.update(changeset)
  end

  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def list_posts_for_user(user_id) do
    Post
    |> where([p], p.user_id == ^user_id)
    |> Repo.all()
  end

  def list_featured_posts() do
    Post
    |> where([p], p.featured == true)
    |> Repo.all()
  end

  def get_draft_post_for_user(user_id) do
    Post
    |> where([p], p.user_id == ^user_id and p.status == :draft)
    |> order_by([p], desc: p.updated_at)
    |> limit(1)
    |> Repo.one()
    # Add this line to preload photos
    |> Repo.preload(:photos)
  end
end
