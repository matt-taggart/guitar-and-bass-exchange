defmodule GuitarAndBassExchangeWeb.UserGetPostsLive do
  use GuitarAndBassExchangeWeb, :live_view
  alias GuitarAndBassExchangeWeb.Plugs.FetchGeocodeData
  alias GuitarAndBassExchange.Post

  def render(assigns) do
    ~H"""
    <.flash_group id="posts-flash-message" flash={@flash} />
    <.navbar current_user={@current_user} geocode_data={@geocode_data} />
    <main class="flex flex-col items-center my-16 mx-8">
      <%= if length(@posts) > 0  do %>
        <div class="w-full max-w-5xl">
          <div class="flex justify-between">
            <h1 class="text-3xl mb-8 text-gray-800">My Posts</h1>
            <.link navigate={~p"/users/#{@current_user.id}/posts/new"}>
              <button class="w-40 h-8 flex items-center justify-center text-xs text-white font-medium bg-blue-700 hover:bg-blue-800 rounded-lg whitespace-nowrap">
                Create New Post
              </button>
            </.link>
          </div>
          <div class="flex flex-col">
            <div class="-m-1.5 overflow-x-auto">
              <div class="p-1.5 min-w-full inline-block align-middle">
                <div class="overflow-hidden">
                  <table class="min-w-full divide-y divide-gray-200">
                    <thead>
                      <tr>
                        <th
                          scope="col"
                          class="px-6 py-3 text-start text-xs font-medium text-gray-500 uppercase"
                        >
                          Title
                        </th>
                        <th
                          scope="col"
                          class="px-3 py-3 text-start text-xs font-medium text-gray-500 uppercase"
                        >
                        </th>
                        <th
                          scope="col"
                          class="px-6 py-3 text-start text-xs font-medium text-gray-500 uppercase"
                        >
                          Brand
                        </th>
                        <th
                          scope="col"
                          class="px-6 py-3 text-start text-xs font-medium text-gray-500 uppercase"
                        >
                          Model
                        </th>
                        <th
                          scope="col"
                          class="px-6 py-3 text-start text-xs font-medium text-gray-500 uppercase"
                        >
                          Price
                        </th>
                        <th
                          scope="col"
                          class="px-6 py-3 text-end text-xs font-medium text-gray-500 uppercase"
                        >
                        </th>
                        <th
                          scope="col"
                          class="px-6 py-3 text-end text-xs font-medium text-gray-500 uppercase"
                        >
                        </th>
                      </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                      <%= for post <- @posts do %>
                        <tr class="hover:bg-gray-100">
                          <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-800">
                            <%= post.title %>
                          </td>

                          <td class="px-3 py-4 whitespace-nowrap text-sm text-gray-800">
                            <%= if post.status == :completed do %>
                              <sl-badge variant="success" pill>
                                Active
                              </sl-badge>
                            <% else %>
                              <sl-badge variant="warning" pill>
                                In Progress
                              </sl-badge>
                            <% end %>
                          </td>
                          <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-800">
                            <%= post.brand %>
                          </td>
                          <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-800">
                            <%= post.model %>
                          </td>
                          <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-800">
                            $<%= :erlang.float_to_binary(post.price, decimals: 2) %>
                          </td>
                          <td class="py-4 whitespace-nowrap text-sm text-gray-800">
                            <div class="relative w-full pt-[95%] bg-gray-100">
                              <img
                                src={
                                  if post.primary_photo && post.primary_photo.url do
                                    post.primary_photo.url
                                  else
                                    ~p"/images/guitar_placeholder.jpeg"
                                  end
                                }
                                alt="Photo of Instrument"
                                class="absolute inset-0 w-full h-full object-cover"
                              />
                            </div>
                          </td>
                          <td class="px-6 py-4 whitespace-nowrap text-end text-sm font-medium">
                            <%= if post.status == :completed do %>
                              <.link navigate={~p"/users/#{@current_user.id}/posts/#{post.id}"}>
                                <button
                                  type="button"
                                  class="inline-flex items-center gap-x-2 text-sm font-semibold rounded-lg border border-transparent text-blue-600 hover:text-blue-800 focus:outline-none focus:text-blue-800 disabled:opacity-50 disabled:pointer-events-none"
                                >
                                  View
                                </button>
                              </.link>
                            <% else %>
                              <.link navigate={~p"/users/#{@current_user.id}/posts/#{post.id}/draft"}>
                                <button
                                  type="button"
                                  class="inline-flex items-center gap-x-2 text-sm font-semibold rounded-lg border border-transparent text-blue-600 hover:text-blue-800 focus:outline-none focus:text-blue-800 disabled:opacity-50 disabled:pointer-events-none"
                                >
                                  Finish Draft
                                </button>
                              </.link>
                            <% end %>
                          </td>
                        </tr>
                      <% end %>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>
      <% else %>
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
            <.link href={~p"/users/#{@current_user.id}/posts/new"}>
              <button
                type="button"
                class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-blue-800 hover:bg-blue-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
              >
                Create a new post
              </button>
            </.link>
          </div>
        </div>
      <% end %>
    </main>
    """
  end

  def mount(_params, session, socket) do
    # TODO: Add error handling for when there is no geocode data (default city)
    geocode_data = FetchGeocodeData.fetch_geocode_data(session)

    posts = Post.Query.list_posts_for_user(socket.assigns.current_user.id)

    {:ok, assign(socket, geocode_data: geocode_data, posts: posts)}
  end
end
