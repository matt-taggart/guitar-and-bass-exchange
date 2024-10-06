defmodule GuitarAndBassExchangeWeb.GoogleAuthController do
  use GuitarAndBassExchangeWeb, :controller

  alias GuitarAndBassExchangeWeb.UserAuth
  alias GuitarAndBassExchange.Accounts
  require Logger

  # Ensure Ueberauth plug is invoked
  plug Ueberauth

  @doc """
  Handles the OAuth request. Let Ueberauth handle the redirection to the provider.
  """
  def request(conn, _params) do
    # Ueberauth handles the redirection, so no need to manually redirect here.
    # You can provide a custom response or simply do nothing.
    # For example, you might render a "Redirecting..." page or handle errors.
    # Here, we'll leave it empty.
    conn
  end

  @doc """
  Handles the OAuth callback. Authenticates the user and updates the session.
  """
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    email = auth.info.email

    case Accounts.get_user_by_email(email) do
      nil ->
        # User does not exist, create a new one
        user_params = %{
          email: email,
          first_name: auth.info.first_name,
          last_name: auth.info.last_name
        }

        case Accounts.register_oauth_user(user_params) do
          {:ok, user} ->
            UserAuth.log_in_user(conn, user)

          {:error, changeset} ->
            Logger.error("Failed to create user #{inspect(changeset)}.")

            conn
            |> put_flash(:error, "Failed to create user.")
            |> redirect(to: ~p"/")
        end

      user ->
        # User exists, log them in
        UserAuth.log_in_user(conn, user)
    end
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Authentication failed.")
    |> redirect(to: ~p"/")
  end
end
