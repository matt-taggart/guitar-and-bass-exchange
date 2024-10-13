defmodule GuitarAndBassExchangeWeb.UserPostInstrumentLive do
  use GuitarAndBassExchangeWeb, :live_view
  alias GuitarAndBassExchange.Post
  alias GuitarAndBassExchange.Post.Query

  def render_list_heading(assigns) do
    ~H"""
    <li class={[
      "flex items-center",
      @is_active && "text-blue-600 dark:text-blue-500"
    ]}>
      <span class="flex items-center after:content-['/'] sm:after:hidden after:mx-2 after:text-gray-200 dark:after:text-gray-500">
        <%= if @is_active do %>
          <svg
            class="w-3.5 h-3.5 sm:w-4 sm:h-4 me-2.5"
            aria-hidden="true"
            xmlns="http://www.w3.org/2000/svg"
            fill="currentColor"
            viewBox="0 0 20 20"
          >
            <path d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5Zm3.707 8.207-4 4a1 1 0 0 1-1.414 0l-2-2a1 1 0 0 1 1.414-1.414L9 10.586l3.293-3.293a1 1 0 0 1 1.414 1.414Z" />
          </svg>
        <% else %>
          <span class="me-2"><%= @step_number %></span>
        <% end %>
        <%= @heading_start %> <span class="hidden sm:inline-flex sm:ms-2"><%= @heading_end %></span>
      </span>
    </li>
    <%= if !@is_last do %>
      <div class="sm:w-[5rem] h-px bg-gray-400 sm:mx-[2rem] border-solid border-1px border-gray-200">
      </div>
    <% end %>
    """
  end

  def render(assigns) do
    ~H"""
    <nav class="border-b border-gray-100 px-5 py-4 flex items-center justify-between gap-8 bg-white z-10">
      <!-- Navigation Content -->
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
      <ol class="flex items-center justify-center text-sm font-medium text-center text-gray-500 sm:text-base max-w-2xl mx-auto mb-16">
        <!-- Step 1: Listing Info -->
        <%= render_list_heading(%{
          is_active: @current_step == 1,
          step_number: 1,
          heading_start: "Listing",
          heading_end: "Info",
          is_last: false
        }) %>
        <!-- Step 2: Upload Photos -->
        <%= render_list_heading(%{
          is_active: @current_step == 2,
          step_number: 2,
          heading_start: "Upload",
          heading_end: "Photos",
          is_last: false
        }) %>
        <!-- Step 3: Payment Info -->
        <%= render_list_heading(%{
          is_active: @current_step == 3,
          step_number: 3,
          heading_start: "Payment",
          heading_end: "Info",
          is_last: true
        }) %>
      </ol>

      <div class="max-w-2xl w-full mx-auto">
        <.header class="text-center mb-8">
          Post Instrument
          <:subtitle>
            List your guitar, bass, or pedal on our exchange.
          </:subtitle>
        </.header>
        <sl-card class="w-full">
          <%= case @current_step do %>
            <% 1 -> %>
              <.simple_form
                for={@form}
                id="post_instrument_form"
                phx-submit="move_to_step_2"
                phx-change="validate"
              >
                <.error :if={@form.errors != []}>
                  Oops, something went wrong! Please check the errors below.
                </.error>

                <.input field={@form[:title]} label="Title" required />
                <.input field={@form[:brand]} label="Brand" required />
                <.input field={@form[:model]} label="Model" required />
                <.input
                  type="select"
                  options={Enum.to_list(1950..Date.utc_today().year) |> Enum.reverse()}
                  field={@form[:year]}
                  label="Year"
                  required
                />
                <.input field={@form[:color]} label="Color" required />
                <.input field={@form[:country_built]} label="Country Built" required />
                <.input
                  type="number"
                  min="1"
                  field={@form[:number_of_strings]}
                  label="Number of Strings"
                  required
                />
                <.input
                  type="select"
                  options={[
                    "New",
                    "Excellent",
                    "Good",
                    "Fair",
                    "Poor"
                  ]}
                  field={@form[:condition]}
                  label="Condition"
                  required
                />
                <.input field={@form[:price]} label="Price" required />
                <.input type="checkbox" field={@form[:shipping]} label="Shipping Available?" required />
                <%= if @form[:shipping].value do %>
                  <.input field={@form[:shipping_cost]} label="Shipping Cost" required />
                <% end %>
                <:actions>
                  <.button phx-disable-with="Posting..." class="w-full">
                    Post Listing
                  </.button>
                </:actions>
              </.simple_form>
            <% 2 -> %>
              <div>Step 2: Upload Photos</div>
            <% 3 -> %>
              <div>Step 3: Payment Info</div>
          <% end %>
        </sl-card>
      </div>
    </main>
    """
  end

  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    if current_user do
      draft_post = Post.Query.get_draft_post_for_user(current_user.id)

      changeset =
        if draft_post do
          Post.changeset(draft_post, %{})
        else
          Post.changeset(%Post{}, %{})
        end

      socket =
        socket
        |> assign(:form, to_form(changeset, as: "post"))
        |> assign(:current_user, current_user)
        |> assign(:current_step, 1)

      {:ok, socket}
    else
      {:ok, socket}
    end
  end

  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      socket.assigns.form.source
      |> Post.changeset(post_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset, as: "post"))}
  end

  def handle_event("move_to_step_2", %{"post" => post_params}, socket) do
    user = socket.assigns.current_user

    # Add the user_id to the post parameters
    post_params = Map.put(post_params, "user_id", user.id)

    case Post.Query.create_post(post_params) do
      {:ok, _post} ->
        # Redirect to the post's show page
        {:noreply,
         socket
         |> assign(:current_step, 2)}

      #  socket
      # |> put_flash(:info, "Post created successfully!")
      # |> push_navigate(to: "/users/#{user.id}/posts/#{post.id}")
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
