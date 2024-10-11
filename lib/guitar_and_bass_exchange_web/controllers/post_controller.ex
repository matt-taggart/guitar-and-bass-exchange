defmodule GuitarAndBassExchangeWeb.PostController do
  use GuitarAndBassExchangeWeb, :controller
  alias GuitarAndBassExchange.Post.Query

  def post(conn, _params) do
    render(conn, :show, layout: false)
  end

  def create_post(conn, %{"post" => post_params}) do
    # Get the current logged-in user
    user = conn.assigns.current_user

    # Include the user_id in the post params
    post_params = Map.put(post_params, "user_id", user.id)

    case Query.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: "/users/#{user.id}/posts/#{post.id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
