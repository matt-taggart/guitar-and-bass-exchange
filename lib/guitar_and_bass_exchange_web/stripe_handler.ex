defmodule GuitarAndBassExchangeWeb.StripeHandler do
  def handle_event(%Stripe.Event{type: "checkout.session.completed"} = event) do
    IO.puts("Checkout session completed: #{inspect(event)}")
    # Handle successful checkout
    # Fulfill the order here
  end

  def handle_event(_), do: :ok
end
