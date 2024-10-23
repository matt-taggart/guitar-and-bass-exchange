defmodule GuitarAndBassExchangeWeb.StripeHandler do
  use GuitarAndBassExchangeWeb, :controller
  require Logger

  def create_checkout_session(conn, _params) do
    payload = Map.get(conn.assigns, :raw_body)
    signature = List.first(Plug.Conn.get_req_header(conn, "stripe-signature"))

    case Stripe.Webhook.construct_event(
           payload,
           signature,
           Application.get_env(:stripe, :signing_secret)
         ) do
      {:ok, event} ->
        handle_event(event)
        send_resp(conn, 200, "")

      {:error, error} ->
        Logger.error("Webhook Error: #{inspect(error)}")
        send_resp(conn, 400, "Webhook Error")
    end
  end

  defp handle_event(%Stripe.Event{type: "checkout.session.completed"} = event) do
    session = event.data.object
    Logger.info("Payment successful! Session: #{inspect(session)}")

    # Handle successful payment
    # Update database
    # Send emails
    # etc.

    :ok
  end

  defp handle_event(_), do: :ok
end
