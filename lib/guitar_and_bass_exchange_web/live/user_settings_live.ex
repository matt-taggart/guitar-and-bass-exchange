defmodule GuitarAndBassExchangeWeb.UserSettingsLive do
  use GuitarAndBassExchangeWeb, :live_view

  alias GuitarAndBassExchange.Accounts

  def render(assigns) do
    ~H"""
    <div class="flex flex-col h-screen">
      <nav class="border-b border-gray-100 px-5 py-4 flex items-center justify-between gap-8 bg-white z-10">
        <div class="flex items-center gap-4">
          <.link href={~p"/"}>
            <h1 class="text-brand text-xl">Guitar And Bass Exchange</h1>
          </.link>
          <div class="flex items-center gap-2">
            <div class="flex items-center gap-1.5">
              <.icon name="hero-map-pin-solid" class="h-7.5 w-7.5 text-blue-500" />
              <div class="text-blue-500">Phoenix, AZ + 30 miles</div>
            </div>
            <div class="text-gray-500 text-[0.85rem] text-md hover:underline hover:text-gray-700 cursor-pointer">
              update
            </div>
          </div>
        </div>
        <div class="flex items-baseline gap-4">
          <%= if @current_user do %>
            <sl-dropdown>
              <button slot="trigger" class="cursor-pointer">
                <sl-avatar label="User avatar" style="--size: 2.5rem;"></sl-avatar>
              </button>
              <sl-menu style="max-width: 200px;">
                <sl-menu-item value="email" role="none" class="unstyled-menu-item">
                  <%= @current_user.email %>
                </sl-menu-item>
                <div class="h-px w-full bg-gray-200"></div>
                <.link
                  href={~p"/users/settings"}
                  class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
                >
                  <sl-menu-item value="Logout">Settings</sl-menu-item>
                </.link>
                <.link
                  href={~p"/users/log_out"}
                  method="delete"
                  class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
                >
                  <sl-menu-item value="delete">Logout</sl-menu-item>
                </.link>
              </sl-menu>
            </sl-dropdown>
          <% else %>
            <a href="/users/log_in" class="text-blue-700 hover:text-blue-900">Sign In</a>
            <a href="/users/register">
              <button
                type="button"
                class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 focus:outline-none"
              >
                Sign Up
              </button>
            </a>
          <% end %>
        </div>
      </nav>
      <div class="flex flex-1 overflow-hidden">
        <aside class="w-1/6 border-r border-gray-100 overflow-y-auto">
          <div class="p-4">
            <h3 class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2 mt-4">
              Settings
            </h3>
            <a
              href="#"
              class="block px-3 py-2 text-gray-700 hover:bg-gray-100 rounded"
              phx-click="toggle_view"
              phx-value-view="account"
            >
              Account
            </a>
            <a
              href="#"
              class="block px-3 py-2 text-gray-700 hover:bg-gray-100 rounded"
              phx-click="toggle_view"
              phx-value-view="billing"
            >
              Billing
            </a>
          </div>
        </aside>
        <main class="flex-1 overflow-y-auto p-8">
          <div class="max-w-2xl w-full mx-auto">
            <%= if @current_view == :account do %>
              <.header class="text-center mb-8">
                Account Settings
                <:subtitle>Manage your account email address and password settings</:subtitle>
              </.header>

              <sl-card class="mb-8 w-full">
                <.simple_form
                  for={@email_form}
                  id="email_form"
                  phx-submit="update_email"
                  phx-change="validate_email"
                >
                  <.input field={@email_form[:email]} type="email" label="Email" required />
                  <.input
                    field={@email_form[:current_password]}
                    name="current_password"
                    id="current_password_for_email"
                    type="password"
                    label="Current password"
                    value={@email_form_current_password}
                    required
                  />
                  <:actions>
                    <.button phx-disable-with="Changing...">Change Email</.button>
                  </:actions>
                </.simple_form>
              </sl-card>

              <sl-card class="w-full">
                <.simple_form
                  for={@password_form}
                  id="password_form"
                  action={~p"/users/log_in?_action=password_updated"}
                  method="post"
                  phx-change="validate_password"
                  phx-submit="update_password"
                  phx-trigger-action={@trigger_submit}
                >
                  <input
                    name={@password_form[:email].name}
                    type="hidden"
                    id="hidden_user_email"
                    value={@current_email}
                  />
                  <.input
                    field={@password_form[:password]}
                    type="password"
                    label="New password"
                    required
                  />
                  <.input
                    field={@password_form[:password_confirmation]}
                    type="password"
                    label="Confirm new password"
                  />
                  <.input
                    field={@password_form[:current_password]}
                    name="current_password"
                    type="password"
                    label="Current password"
                    id="current_password_for_password"
                    value={@current_password}
                    required
                  />
                  <:actions>
                    <.button phx-disable-with="Changing...">Change Password</.button>
                  </:actions>
                </.simple_form>
              </sl-card>
            <% else %>
              <.header class="text-center mb-8">
                Billing
                <:subtitle>Manage your credit card info & payment details</:subtitle>
              </.header>

              <sl-card class="mb-8 w-full">
                <.simple_form
                  for={@billing_form}
                  id="email_form"
                  phx-submit="update_billing"
                  phx-change="validate_billing"
                >
                  <.input field={@billing_form[:first_name]} label="First Name" required />
                  <.input field={@billing_form[:last_name]} label="Last Name" required />
                  <:actions>
                    <.button phx-disable-with="Changing...">Update Address</.button>
                  </:actions>
                </.simple_form>
              </sl-card>
            <% end %>
          </div>
        </main>
      </div>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    email_changeset = Accounts.change_user_email(user)
    password_changeset = Accounts.change_user_password(user)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:billing_form, to_form(%{"first_name" => "", "last_name" => ""}))
      |> assign(:trigger_submit, false)
      |> assign(:current_view, :account)

    {:ok, socket}
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Accounts.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm_email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Accounts.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Accounts.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end

  def handle_event("toggle_view", params, socket) do
    %{"view" => view} = params

    {:noreply, assign(socket, :current_view, String.to_atom(view))}
  end

  def handle_event("validate_billing", %{"billing" => billing_params}, socket) do
    billing_form =
      billing_params
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, billing_form: billing_form)}
  end

  def handle_event("update_billing", %{"billing" => _billing_params}, socket) do
    # Here you would typically update the billing information in your database
    # For now, we'll just display a flash message
    {:noreply, put_flash(socket, :info, "Billing information updated successfully.")}
  end
end
