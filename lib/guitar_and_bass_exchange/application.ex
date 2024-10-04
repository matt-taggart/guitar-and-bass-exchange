defmodule GuitarAndBassExchange.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GuitarAndBassExchangeWeb.Telemetry,
      GuitarAndBassExchange.Repo,
      {DNSCluster, query: Application.get_env(:guitar_and_bass_exchange, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: GuitarAndBassExchange.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: GuitarAndBassExchange.Finch},
      # Start a worker by calling: GuitarAndBassExchange.Worker.start_link(arg)
      # {GuitarAndBassExchange.Worker, arg},
      # Start to serve requests, typically the last entry
      GuitarAndBassExchangeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GuitarAndBassExchange.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GuitarAndBassExchangeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
