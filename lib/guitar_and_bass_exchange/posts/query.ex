defmodule GuitarAndBassExchange.Post.Query do
  import Ecto.Query, warn: false
  alias GuitarAndBassExchange.Repo
  alias GuitarAndBassExchange.Post

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

  def get_draft_post_for_user(user_id) do
    Post
    |> where([p], p.user_id == ^user_id and p.status == :draft)
    |> order_by([p], desc: p.updated_at)
    |> limit(1)
    |> Repo.one()
  end
end
