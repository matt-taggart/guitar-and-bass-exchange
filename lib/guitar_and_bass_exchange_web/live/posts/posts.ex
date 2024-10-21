defmodule GuitarAndBassExchangeWeb.UserGetPostsLive do
  use GuitarAndBassExchangeWeb, :live_view
  alias GuitarAndBassExchangeWeb.Plugs.FetchGeocodeData

  def render(assigns) do
    ~H"""
    <.navbar current_user={@current_user} geocode_data={@geocode_data} />
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
          You haven't posted any instruments yet. Create a post to showcase your musical equipment to our extensive network of buyers. Our streamlined process helps you reach a broader audience, potentially accelerating your sale and maximizing your instrument's value.
        </div>
        <div class="flex">
          <.link href={~p"/users/#{@current_user.id}/post/new"}>
            <button
              type="button"
              class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-blue-800 hover:bg-blue-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
            >
              Create a new post
            </button>
          </.link>
        </div>
      </div>
    </main>
    """
  end

  def mount(_params, session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")

    geocode_data = FetchGeocodeData.fetch_geocode_data(session, socket)

    {:ok, assign(socket, form: form, geocode_data: geocode_data), temporary_assigns: [form: form]}
  end
end
