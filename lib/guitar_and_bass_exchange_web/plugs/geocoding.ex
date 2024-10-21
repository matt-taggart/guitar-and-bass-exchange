defmodule GuitarAndBassExchangeWeb.Plugs.FetchGeocodeData do
  import Plug.Conn

  alias GuitarAndBassExchangeWeb.Geocoding

  def init(default), do: default

  def call(conn, _opts) do
    # Check if the geocode data is already stored in the session
    case get_session(conn, :geocode_data) do
      nil ->
        # If not cached, fetch and store in the session
        geocode_data = fetch_and_cache_geocode_data(conn)
        put_session(conn, :geocode_data, geocode_data)
        assign(conn, :geocode_data, geocode_data)

      geocode_data ->
        # If already cached, assign it to the conn
        assign(conn, :geocode_data, geocode_data)
    end
  end

  defp fetch_and_cache_geocode_data(_conn) do
    case Geocoding.geocode_ip() do
      {:ok, data} ->
        %{
          city: get_in(data, ["address", "city"]),
          state: get_in(data, ["address", "stateCode"]),
          zip_code: get_in(data, ["address", "zip_code"]),
          coordinates: get_in(data, ["location", "coordinates"])
        }

      {:error, _} ->
        nil
    end
  end

  def fetch_geocode_data(session, socket) do
    case Map.get(session, "geocode_data") do
      nil ->
        fetch_and_cache_geocode_data(socket)

      geocode_data ->
        geocode_data
    end
  end
end
