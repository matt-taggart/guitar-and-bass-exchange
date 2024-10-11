defmodule GuitarAndBassExchangeWeb.PostController do
  use GuitarAndBassExchangeWeb, :controller
  alias GuitarAndBassExchange.Posts
  alias GuitarAndBassExchange.Posts.Post

  plug :require_authenticated_user when action in [:create, :new]

  def create(conn, %{"post" => post_params}) do
    # Get the current logged-in user
    user = conn.assigns.current_user

    # Include the user_id in the post params
    post_params = Map.put(post_params, "user_id", user.id)

    case Posts.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
