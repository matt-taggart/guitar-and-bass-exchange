defmodule GuitarAndBassExchangeWeb.CheckoutCancelLive do
  use GuitarAndBassExchangeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h2>Payment Cancelled</h2>
      <p>Your payment was cancelled. No charges were made.</p>
      <.link navigate={~p"/"} class="button">Try Again</.link>
    </div>
    """
  end
end
