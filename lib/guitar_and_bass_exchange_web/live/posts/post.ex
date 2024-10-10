defmodule GuitarAndBassExchangeWeb.UserPostInstrumentLive do
  use GuitarAndBassExchangeWeb, :live_view

  def render(assigns) do
    ~H"""
    <nav class="border-b border-gray-100 px-5 py-4 flex items-center justify-between gap-8 bg-white z-10">
      <div class="flex items-center gap-4">
        <.link href={~p"/"}>
          <h1 class="text-brand text-xl font-semibold">Guitar And Bass Exchange</h1>
        </.link>
        <div class="mx-10">
          <div class="relative">
            <span class="absolute inset-y-0 left-0 flex items-center pl-3">
              <svg class="w-5 h-5 text-gray-400" viewBox="0 0 24 24" fill="none">
                <path
                  d="M21 21L15 15M17 10C17 13.866 13.866 17 10 17C6.13401 17 3 13.866 3 10C3 6.13401 6.13401 3 10 3C13.866 3 17 6.13401 17 10Z"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                />
              </svg>
            </span>
            <input
              type="text"
              class="w-full py-2 pl-10 pr-4 text-gray-700 bg-white border rounded-md focus:border-blue-400 focus:outline-none focus:ring focus:ring-opacity-40 focus:ring-blue-300"
              placeholder="Search"
            />
          </div>
        </div>
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
          <sl-button variant="default" size="small">
            <sl-icon slot="prefix" name="chat-left-text"></sl-icon>
            Messages
          </sl-button>
          <.link href={~p"/users/posts"}>
            <sl-button variant="default" size="small">
              <sl-icon slot="prefix" name="file-earmark-plus"></sl-icon>
              Posts
            </sl-button>
          </.link>
          <sl-button variant="default" size="small">
            <sl-icon slot="prefix" name="bookmark"></sl-icon>
            Favorites
          </sl-button>
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
    <main class="flex flex-col items-center my-16 mx-8">
      <div class="max-w-2xl w-full mx-auto">
        <.header class="text-center mb-8">
          Post Instrument
          <:subtitle>
            List your guitar, bass, or pedal on our exchange.
          </:subtitle>
        </.header>

        <sl-card class="w-full">
          <.simple_form
            for={@form}
            id="post_instrument_form"
            phx-submit="post_instrument"
            phx-change="validate"
          >
            <.error :if={@form.errors != []}>
              Oops, something went wrong! Please check the errors below.
            </.error>

            <.input field={@form[:title]} label="Title" required />
            <.input field={@form[:brand]} label="Brand" required />
            <.input field={@form[:model]} label="Model" required />
            <.input field={@form[:year]} label="Year" required />
            <.input field={@form[:color]} label="Color" required />
            <.input field={@form[:country_buiilt]} label="Country Built" required />
            <.input field={@form[:number_of_strings]} label="Number of Strings" required />
            <.input
              type="select"
              options={
                %{
                  "New" => "New",
                  "Excellent" => "Excellent",
                  "Good" => "Good",
                  "Fair" => "Fair",
                  "Poor" => "Poor"
                }
              }
              field={@form[:condition]}
              label="Condition"
              required
            />
            <.input field={@form[:cost]} label="Cost" required />
            <.input
              type="checkbox"
              field={@form[:shipping_available]}
              label="Shipping Available?"
              required
            />
            <.input field={@form[:shipping_cost]} label="Shipping Cost" required />
            <:actions>
              <.button phx-disable-with="Resetting..." class="w-full">Post Listing</.button>
            </:actions>
          </.simple_form>
        </sl-card>
      </div>
    </main>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
