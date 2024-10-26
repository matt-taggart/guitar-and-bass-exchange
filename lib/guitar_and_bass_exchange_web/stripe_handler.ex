defmodule GuitarAndBassExchangeWeb.StripeHandler do
  require Logger

  def create_payment_intent(amount) do
    # Convert amount to cents (Stripe expects amounts in cents)
    amount_in_cents = trunc(amount * 100)

    case Stripe.PaymentIntent.create(%{
      amount: amount_in_cents,
      currency: "usd",
      payment_method_types: ["card"],
      # Optional metadata
      metadata: %{
        type: "promotion"
      }
    }) do
      {:ok, payment_intent} -> {:ok, payment_intent}
      {:error, %Stripe.Error{} = error} -> {:error, error}
      {:error, _} -> {:error, %{message: "An unexpected error occurred"}}
    end
  end
end
