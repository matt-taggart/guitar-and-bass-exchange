defmodule GuitarAndBassExchangeWeb.UserGetPostLive do
  use GuitarAndBassExchangeWeb, :live_view
  alias GuitarAndBassExchangeWeb.Plugs.FetchGeocodeData
  alias GuitarAndBassExchange.Post

  def render(assigns) do
    ~H"""
    <.flash_group id="posts-flash-message" flash={@flash} />
    <.navbar current_user={@current_user} geocode_data={@geocode_data} />

    <div class="max-w-[1200px] mx-auto px-6 py-8">
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 mt-3">
        <!-- Left Column - Images -->
        <div class="space-y-6">
          <div class="bg-gray-100 rounded-xl shadow-sm border border-gray-200 overflow-hidden">
            <%= if @post.primary_photo do %>
              <img
                src={@post.primary_photo.url}
                alt="Primary instrument photo"
                class="w-full h-auto object-cover"
              />
            <% else %>
              <div class="flex items-center justify-center h-[400px]">
                <p class="text-gray-400">No photos uploaded</p>
              </div>
            <% end %>
          </div>

          <div class="grid grid-cols-4 gap-4">
            <%= for photo <- Enum.filter(@post.photos, &(&1.id != @post.primary_photo_id)) do %>
              <div class="aspect-square rounded-xl shadow-sm border border-gray-200 overflow-hidden bg-gray-100">
                <img
                  src={photo.url}
                  alt="Instrument photo"
                  class="w-full h-full object-cover cursor-pointer hover:opacity-75 transition"
                  phx-click="show_stored_preview"
                  phx-value-url={photo.url}
                />
              </div>
            <% end %>
          </div>
        </div>
        <!-- Right Column - Details -->
        <div>
          <h1 class="text-3xl font-bold text-gray-900"><%= @post.title %></h1>

          <div class="text-2xl text-gray-500 mt-2 mb-7">
            $<%= :erlang.float_to_binary(@post.price || 0.0, decimals: 2) %>
          </div>

          <%= if @post.shipping do %>
            <div class="bg-gray-50 rounded-xl shadow-sm border border-gray-200 p-4 flex items-center gap-4">
              <div class="bg-white p-2 rounded-lg">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="h-6 w-6 text-blue-600"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M5 13l4 4L19 7"
                  />
                </svg>
              </div>
              <div>
                <p class="font-medium">Shipping Available</p>
                <p class="text-gray-500">
                  Cost: $<%= :erlang.float_to_binary(@post.shipping_cost || 0.0, decimals: 2) %>
                </p>
              </div>
            </div>
          <% end %>

          <div>
            <h3 class="text-lg font-bold text-gray-900 mb-3">DETAILS</h3>
            <div class="space-y-4 bg-white rounded-xl shadow-sm border border-gray-200 p-6">
              <.detail_row label="Brand" value={@post.brand} />
              <.detail_row label="Model" value={@post.model} />
              <.detail_row label="Year" value={@post.year} />
              <.detail_row label="Color" value={@post.color} />
              <.detail_row label="Country Built" value={@post.country_built} />
              <.detail_row label="Number of Strings" value={@post.number_of_strings} />
              <.detail_row label="Condition" value={@post.condition} />
            </div>

            <div class="pt-6 border-t mt-6">
              <h3 class="text-lg font-bold text-gray-900 mb-4">Description</h3>
              <p class="text-gray-600 whitespace-pre-wrap"><%= @post.description %></p>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp detail_row(assigns) do
    ~H"""
    <div class="flex justify-between py-2 border-b last:border-b-0">
      <dt class="text-gray-500"><%= @label %></dt>
      <dd class="text-gray-900 font-medium"><%= @value %></dd>
    </div>
    """
  end

  def mount(%{"post_id" => post_id}, session, socket) do
    geocode_data = FetchGeocodeData.fetch_geocode_data(session)
    post = Post.Query.get_post_for_user(socket.assigns.current_user.id, post_id)
    IO.inspect(post)

    {:ok, assign(socket, post: post, geocode_data: geocode_data)}
  end
end
