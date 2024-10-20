defmodule GuitarAndBassExchangeWeb.PageController do
  use GuitarAndBassExchangeWeb, :controller
  alias GuitarAndBassExchange.Post.Query
  alias GuitarAndBassExchangeWeb.Geocoding

  def home(conn, _params) do
    posts = Query.list_featured_posts()

    # Geocode the addresses
    geocode_data =
      case Geocoding.geocode_ip() do
        {:ok, data} ->
          %{
            city: get_in(data, ["address", "city"]),
            state: get_in(data, ["address", "state"]),
            zip_code: get_in(data, ["address", "zip_code"]),
            coordinates: get_in(data, ["location", "coordinates"])
          }

        {:error, _} ->
          nil
      end

    render(conn, :home, layout: false, posts: posts, geocode_data: geocode_data)
  end

  def terms(conn, _params) do
    render(conn, :terms, layout: false)
  end

  def privacy(conn, _params) do
    render(conn, :privacy, layout: false)
  end
end
