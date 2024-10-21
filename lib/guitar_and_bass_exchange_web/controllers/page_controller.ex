defmodule GuitarAndBassExchangeWeb.PageController do
  use GuitarAndBassExchangeWeb, :controller
  alias GuitarAndBassExchange.Post.Query

  def home(conn, _params) do
    posts = Query.list_featured_posts()

    render(conn, :home, layout: false, posts: posts)
  end

  def terms(conn, _params) do
    render(conn, :terms, layout: false)
  end

  def privacy(conn, _params) do
    render(conn, :privacy, layout: false)
  end
end
