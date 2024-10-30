defmodule GuitarAndBassExchangeWeb.StripeHandler do
  require Logger

  def create_payment_intent(amount) do
    # Convert amount to cents (Stripe expects amounts in cents)
    amount_in_cents = trunc(amount * 100)

    params = %{
      amount: amount_in_cents,
      currency: "usd",
      payment_method_types: ["card"],
      # Optional metadata
      metadata: %{
        type: "promotion"
      }
    }

    case Stripe.PaymentIntent.create(params) do
      {:ok, intent} ->
        {:ok, intent}

      {:error, %Stripe.Error{} = error} ->
        {:error, error}

      {:error, _} ->
        {:error, %{message: "An unexpected error occurred"}}
    end
  end
end
