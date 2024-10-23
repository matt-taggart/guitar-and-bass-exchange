defmodule GuitarAndBassExchangeWeb.CheckoutSuccessLive do
  use GuitarAndBassExchangeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h2>Payment Successful!</h2>
      <p>Thank you for your purchase.</p>
      <.link navigate={~p"/"} class="button">Return Home</.link>
    </div>
    """
  end
end
