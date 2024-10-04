defmodule GuitarAndBassExchange.Repo do
  use Ecto.Repo,
    otp_app: :guitar_and_bass_exchange,
    adapter: Ecto.Adapters.Postgres
end
