defmodule GuitarAndBassExchangeWeb.Router do
  use GuitarAndBassExchangeWeb, :router

  import GuitarAndBassExchangeWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GuitarAndBassExchangeWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user

    plug GuitarAndBassExchangeWeb.Plugs.FetchGeocodeData
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_raw_body_for_stripe
  end

  defp fetch_raw_body_for_stripe(conn, _opts) do
    {:ok, raw_body, conn} = Plug.Conn.read_body(conn)
    assign(conn, :raw_body, raw_body)
  end

  scope "/", GuitarAndBassExchangeWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/terms", PageController, :terms
    get "/privacy", PageController, :privacy
  end

  scope "/", GuitarAndBassExchangeWeb do
    pipe_through :browser

    live "/checkout", CheckoutLive
    live "/checkout/success", CheckoutSuccessLive
    live "/checkout/cancel", CheckoutCancelLive
  end

  scope "/api", GuitarAndBassExchangeWeb do
    pipe_through :api
    post "/webhook", StripeWebhookController, :webhook
  end

  # Other scopes may use custom stacks.
  # scope "/api", GuitarAndBassExchangeWeb dousers
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:guitar_and_bass_exchange, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: GuitarAndBassExchangeWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", GuitarAndBassExchangeWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{GuitarAndBassExchangeWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", GuitarAndBassExchangeWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{GuitarAndBassExchangeWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
      live "/rooms", ChatLive.Root, :index
      live "/rooms/:id", ChatLive.Root, :show
      live "/users/:user_id/posts", UserGetPostsLive, :show
      live "/users/:user_id/posts/new", UserPostInstrumentLive, :new
      live "/users/:user_id/posts/:post_id/draft", UserPostInstrumentLive, :draft
      live "/users/:user_id/posts/:post_id/edit", UserPostInstrumentLive, :edit
      live "/users/:user_id/posts/:post_id", UserGetPostLive, :show
    end
  end

  scope "/", GuitarAndBassExchangeWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{GuitarAndBassExchangeWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  # OAuth Routes
  scope "/auth", GuitarAndBassExchangeWeb do
    pipe_through :browser

    # These routes are handled by Ueberauth
    get "/:provider", GoogleAuthController, :request
    get "/:provider/callback", GoogleAuthController, :callback
  end
end
