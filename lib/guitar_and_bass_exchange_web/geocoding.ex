defmodule GuitarAndBassExchangeWeb.Geocoding do
  @moduledoc """
  This module contains functions for geocoding addresses.
  """

  def geocode_ip() do
    url = "https://api.radar.io/v1/geocode/ip"
    radar_api_key = System.get_env("RADAR_API_KEY") |> String.trim()

    headers = [
      {"Authorization", radar_api_key},
      {"Content-Type", "application/json"},
      {"Accept", "application/json"}
    ]

    ssl_options =
      case Mix.env() do
        :dev ->
          [ssl: [{:verify, :verify_none}]]

        _ ->
          []
      end

    case HTTPoison.get(url, headers, ssl_options) do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        case status_code do
          200 ->
            case Jason.decode(body) do
              {:ok, json_data} ->
                {:ok, json_data}

              {:error, _} ->
                {:error, :invalid_json}
            end

          401 ->
            IO.puts("Unauthorized - Check your API key and permissions")
            {:error, :unauthorized}

          _ ->
            {:error, "HTTP Error #{status_code}: #{body}"}
        end

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.puts("HTTPoison Error: #{inspect(reason)}")
        {:error, reason}
    end
  end
end
