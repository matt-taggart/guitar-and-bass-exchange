# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :guitar_and_bass_exchange,
  ecto_repos: [GuitarAndBassExchange.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :guitar_and_bass_exchange, GuitarAndBassExchangeWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: GuitarAndBassExchangeWeb.ErrorHTML, json: GuitarAndBassExchangeWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: GuitarAndBassExchange.PubSub,
  live_view: [signing_salt: "h4mRaRfR"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :guitar_and_bass_exchange, GuitarAndBassExchange.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  guitar_and_bass_exchange: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  guitar_and_bass_exchange: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [default_scope: "email profile"]}
  ]

config :guitar_and_bass_exchange, YourApp.Mailer,
  adapter: Swoosh.Adapters.SMTP,
  relay: "mail.privateemail.com",
  port: 465,
  ssl: true,
  tls: :always,
  auth: :always,
  username: "support@guitarandbassexchange.com",
  password: System.get_env("SMTP_PASSWORD")

config :ex_aws,
  region: "nyc3"

config :ex_aws, :s3,
  scheme: "https://",
  host:
    "#{System.get_env("SPACES_NAME")}.#{System.get_env("SPACES_REGION")}.digitaloceanspaces.com"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
