defmodule GuitarAndBassExchangeWeb.UserGetPostsLive do
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
          <.link href={~p"/users/#{@current_user.id}/posts"}>
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
      <div
        id="alert-additional-content-1"
        class="p-8 mb-4 text-blue-800 border border-blue-300 rounded-lg bg-blue-50 max-w-2xl w-full mx-auto mb-24"
        role="alert"
      >
        <div class="flex items-center">
          <svg
            class="flex-shrink-0 w-4 h-4 me-2"
            aria-hidden="true"
            xmlns="http://www.w3.org/2000/svg"
            fill="currentColor"
            viewBox="0 0 20 20"
          >
            <path d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5ZM9.5 4a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3ZM12 15H8a1 1 0 0 1 0-2h1v-3H8a1 1 0 0 1 0-2h2a1 1 0 0 1 1 1v4h1a1 1 0 0 1 0 2Z" />
          </svg>
          <span class="sr-only">Info</span>
          <h3 class="text-lg font-medium">Ready to sell your instrument?</h3>
        </div>
        <div class="mt-2 mb-4 text-sm">
          You haven't listed any instruments yet. Create a listing to showcase your musical equipment to our extensive network of buyers. Our streamlined process helps you reach a broader audience, potentially accelerating your sale and maximizing your instrument's value.
        </div>
        <div class="flex">
          <.link href={~p"/users/#{@current_user.id}/post/new"}>
            <button
              type="button"
              class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-blue-800 hover:bg-blue-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
            >
              Create a new listing
            </button>
          </.link>
        </div>
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
