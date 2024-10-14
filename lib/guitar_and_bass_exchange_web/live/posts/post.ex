defmodule GuitarAndBassExchangeWeb.UserPostInstrumentLive do
  use GuitarAndBassExchangeWeb, :live_view
  alias GuitarAndBassExchange.Post
  require Logger

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
        <!-- Step Headings -->
        <%= render_list_heading(%{
          is_active: @current_step == 1,
          step_number: 1,
          heading_start: "Listing",
          heading_end: "Info",
          is_last: false
        }) %>
        <%= render_list_heading(%{
          is_active: @current_step == 2,
          step_number: 2,
          heading_start: "Upload",
          heading_end: "Photos",
          is_last: false
        }) %>
        <%= render_list_heading(%{
          is_active: @current_step == 3,
          step_number: 3,
          heading_start: "Payment",
          heading_end: "Info",
          is_last: true
        }) %>
      </ol>

      <div class="max-w-2xl w-full mx-auto">
        <%= case @current_step do %>
          <% 1 -> %>
            <!-- Step 1: Listing Info -->
            <.header class="text-center mb-8">
              Listing Info
              <:subtitle>
                List basic info about the guitar, bass, or pedal that you're posting.
              </:subtitle>
            </.header>
            <sl-card class="w-full">
              <.simple_form for={@form} id="post_instrument_form" phx-submit="advance_to_step_2">
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
                  options={["New", "Excellent", "Good", "Fair", "Poor"]}
                  field={@form[:condition]}
                  label="Condition"
                  required
                />
                <.input field={@form[:price]} label="Price" required />
                <.input
                  type="checkbox"
                  field={@form[:shipping]}
                  label="Shipping Available?"
                  phx-click="toggle_shipping"
                />
                <%= if @form[:shipping].value == true do %>
                  <.input field={@form[:shipping_cost]} label="Shipping Cost" required />
                <% end %>
                <:actions>
                  <.button phx-disable-with="Posting..." class="w-full">
                    Upload Info
                  </.button>
                </:actions>
              </.simple_form>
            </sl-card>
          <% 2 -> %>
            <!-- Step 2: Photos -->
            <.header class="text-center mb-8">
              Photos
              <:subtitle>
                Select up to 8 photos of the instrument you're posting. Photos should be less than 10MB.
              </:subtitle>
            </.header>
            <sl-card class="w-full">
              <form phx-submit="save" phx-change="validate" class="w-full">
                <div class="w-full grid gap-5">
                  <!-- Upload Container -->
                  <div class="w-full py-9 bg-gray-50 rounded-2xl border border-gray-300 border-dashed">
                    <div class="grid gap-3">
                      <!-- Upload Instructions -->
                      <div>
                        <!-- SVG Icon -->
                        <svg
                          class="mx-auto mb-1"
                          width="40"
                          height="40"
                          viewBox="0 0 40 40"
                          fill="none"
                          xmlns="http://www.w3.org/2000/svg"
                        >
                          <g id="File">
                            <path
                              id="icon"
                              d="M31.6497 10.6056L32.2476 10.0741L31.6497 10.6056ZM28.6559 7.23757L28.058 7.76907L28.058 7.76907L28.6559 7.23757ZM26.5356 5.29253L26.2079 6.02233L26.2079 6.02233L26.5356 5.29253ZM33.1161 12.5827L32.3683 12.867V12.867L33.1161 12.5827ZM31.8692 33.5355L32.4349 34.1012L31.8692 33.5355ZM24.231 11.4836L25.0157 11.3276L24.231 11.4836ZM26.85 14.1026L26.694 14.8872L26.85 14.1026ZM11.667 20.8667C11.2252 20.8667 10.867 21.2248 10.867 21.6667C10.867 22.1085 11.2252 22.4667 11.667 22.4667V20.8667ZM25.0003 22.4667C25.4422 22.4667 25.8003 22.1085 25.8003 21.6667C25.8003 21.2248 25.4422 20.8667 25.0003 20.8667V22.4667ZM11.667 25.8667C11.2252 25.8667 10.867 26.2248 10.867 26.6667C10.867 27.1085 11.2252 27.4667 11.667 27.4667V25.8667ZM20.0003 27.4667C20.4422 27.4667 20.8003 27.1085 20.8003 26.6667C20.8003 26.2248 20.4422 25.8667 20.0003 25.8667V27.4667ZM23.3337 34.2H16.667V35.8H23.3337V34.2ZM7.46699 25V15H5.86699V25H7.46699ZM32.5337 15.0347V25H34.1337V15.0347H32.5337ZM16.667 5.8H23.6732V4.2H16.667V5.8ZM23.6732 5.8C25.2185 5.8 25.7493 5.81639 26.2079 6.02233L26.8633 4.56274C26.0191 4.18361 25.0759 4.2 23.6732 4.2V5.8ZM29.2539 6.70608C28.322 5.65771 27.7076 4.94187 26.8633 4.56274L26.2079 6.02233C26.6665 6.22826 27.0314 6.6141 28.058 7.76907L29.2539 6.70608ZM34.1337 15.0347C34.1337 13.8411 34.1458 13.0399 33.8638 12.2984L32.3683 12.867C32.5216 13.2702 32.5337 13.7221 32.5337 15.0347H34.1337ZM31.0518 11.1371C31.9238 12.1181 32.215 12.4639 32.3683 12.867L33.8638 12.2984C33.5819 11.5569 33.0406 10.9662 32.2476 10.0741L31.0518 11.1371ZM16.667 34.2C14.2874 34.2 12.5831 34.1983 11.2872 34.0241C10.0144 33.8529 9.25596 33.5287 8.69714 32.9698L7.56577 34.1012C8.47142 35.0069 9.62375 35.4148 11.074 35.6098C12.5013 35.8017 14.3326 35.8 16.667 35.8V34.2ZM5.86699 25C5.86699 27.3344 5.86529 29.1657 6.05718 30.593C6.25217 32.0432 6.66012 33.1956 7.56577 34.1012L8.69714 32.9698C8.13833 32.411 7.81405 31.6526 7.64292 30.3798C7.46869 29.0839 7.46699 27.3796 7.46699 25H5.86699ZM23.3337 35.8C25.6681 35.8 27.4993 35.8017 28.9266 35.6098C30.3769 35.4148 31.5292 35.0069 32.4349 34.1012L31.3035 32.9698C30.7447 33.5287 29.9863 33.8529 28.7134 34.0241C27.4175 34.1983 25.7133 34.2 23.3337 34.2V35.8ZM32.5337 25C32.5337 27.3796 32.532 29.0839 32.3577 30.3798C32.1866 31.6526 31.8623 32.411 31.3035 32.9698L32.4349 34.1012C33.3405 33.1956 33.7485 32.0432 33.9435 30.593C34.1354 29.1657 34.1337 27.3344 34.1337 25H32.5337ZM7.46699 15C7.46699 12.6204 7.46869 10.9161 7.64292 9.62024C7.81405 8.34738 8.13833 7.58897 8.69714 7.03015L7.56577 5.89878C6.66012 6.80443 6.25217 7.95676 6.05718 9.40704C5.86529 10.8343 5.86699 12.6656 5.86699 15H7.46699ZM16.667 4.2C14.3326 4.2 12.5013 4.1983 11.074 4.39019C9.62375 4.58518 8.47142 4.99313 7.56577 5.89878L8.69714 7.03015C9.25596 6.47133 10.0144 6.14706 11.2872 5.97592C12.5831 5.8017 14.2874 5.8 16.667 5.8V4.2ZM23.367 5V10H24.967V5H23.367ZM28.3337 14.9667H33.3337V13.3667H28.3337V14.9667ZM23.367 10C23.367 10.7361 23.3631 11.221 23.4464 11.6397L25.0157 11.3276C24.9709 11.1023 24.967 10.8128 24.967 10H23.367ZM28.3337 13.3667C27.5209 13.3667 27.2313 13.3628 27.0061 13.318L26.694 14.8872C27.1127 14.9705 27.5976 14.9667 28.3337 14.9667V13.3667ZM23.4464 11.6397C23.7726 13.2794 25.0543 14.5611 26.694 14.8872L27.0061 13.318C26.0011 13.1181 25.2156 12.3325 25.0157 11.3276L23.4464 11.6397ZM11.667 22.4667H25.0003V20.8667H11.667V22.4667ZM11.667 27.4667H20.0003V25.8667H11.667V27.4667Z"
                              fill="#4F46E5"
                            />
                          </g>
                        </svg>
                        <h2 class="text-center text-gray-400 text-xs font-light leading-4">
                          PNG, JPG or WebP, smaller than 5MB
                        </h2>
                      </div>
                      <div class="grid gap-2">
                        <h4 class="text-center text-gray-900 text-sm font-medium leading-snug">
                          Drag and Drop your file here or
                        </h4>
                        <div class="flex items-center justify-center">
                          <label>
                            <.live_file_input upload={@uploads.images} class="hidden" />
                            <div class="flex w-28 h-9 px-2 flex-col bg-blue-600 rounded-full shadow text-white text-xs font-semibold leading-4 items-center justify-center cursor-pointer focus:outline-none">
                              Choose File
                            </div>
                          </label>
                        </div>
                      </div>
                    </div>
                  </div>
                  <!-- Display Upload Entries with Progress Bars -->
                  <%= for entry <- @uploads.images.entries do %>
                    <figure>
                      <.live_img_preview entry={entry} />
                    </figure>
                    <div class="w-full grid gap-1">
                      <!-- Uploaded File Info -->
                      <div class="flex items-center justify-between gap-2">
                        <div class="flex items-center gap-2">
                          <!-- Use a placeholder image -->
                          <div class="grid gap-1">
                            <h4 class="text-gray-900 text-sm font-normal leading-snug">
                              <%= entry.client_name %>
                            </h4>
                            <h5 class="text-gray-400 text-xs font-normal leading-4">
                              <%= if entry.done? do %>
                                Upload complete
                              <% else %>
                                Uploading...
                              <% end %>
                            </h5>
                          </div>
                        </div>
                        <!-- Upload Status Icon -->
                        <%= if entry.done? do %>
                          <!-- Complete Icon -->
                          <svg
                            xmlns="http://www.w3.org/2000/svg"
                            width="24"
                            height="24"
                            viewBox="0 0 24 24"
                            fill="none"
                          >
                            <g id="Upload 3">
                              <path
                                id="icon"
                                d="M15 9L12 12M12 12L9 15M12 12L9 9M12 12L15 15M21 12C21 16.9706 16.9706 21 12 21C7.02944 21 3 16.9706 3 12C3 7.02944 7.02944 3 12 3C16.9706 3 21 7.02944 21 12Z"
                                stroke="#4CAF50"
                                stroke-width="1.6"
                                stroke-linecap="round"
                              />
                            </g>
                          </svg>
                        <% else %>
                          <!-- In-progress Icon -->
                          <svg
                            xmlns="http://www.w3.org/2000/svg"
                            width="24"
                            height="24"
                            viewBox="0 0 24 24"
                            fill="none"
                          >
                            <g id="Upload 3">
                              <path
                                id="icon"
                                d="M15 9L12 12M12 12L9 15M12 12L9 9M12 12L15 15M21 12C21 16.9706 16.9706 21 12 21C7.02944 21 3 16.9706 3 12C3 7.02944 7.02944 3 12 3C16.9706 3 21 7.02944 21 12Z"
                                stroke="#D1D5DB"
                                stroke-width="1.6"
                                stroke-linecap="round"
                              />
                            </g>
                          </svg>
                        <% end %>
                      </div>
                      <!-- Progress Bar -->
                      <div class="relative flex items-center gap-2.5 py-1.5">
                        <div class="relative w-full h-2.5 overflow-hidden rounded-3xl bg-gray-100">
                          <div
                            role="progressbar"
                            aria-valuenow={entry.progress}
                            aria-valuemin="0"
                            aria-valuemax="100"
                            style={"width: #{entry.progress}%"}
                            class="flex h-full items-center justify-center bg-indigo-600 text-white rounded-3xl"
                          >
                          </div>
                        </div>
                        <span class="ml-2 bg-white rounded-full text-gray-800 text-xs font-medium flex justify-center items-center">
                          <%= entry.progress %>%
                        </span>
                      </div>
                    </div>
                  <% end %>
                  <!-- Display Uploaded Files -->
                  <%= for url <- @uploaded_files do %>
                    <div class="w-full grid gap-1">
                      <div class="flex items-center justify-between gap-2">
                        <div class="flex items-center gap-2">
                          <!-- Display Uploaded Image Thumbnail with Correct URL -->
                          <img src={url} alt="Uploaded Photo" class="w-10 h-10 rounded-md" />
                          <div class="grid gap-1">
                            <h4 class="text-gray-900 text-sm font-normal leading-snug">
                              <%= Path.basename(url) %>
                            </h4>
                            <h5 class="text-gray-400 text-xs font-normal leading-4">
                              Upload complete
                            </h5>
                          </div>
                        </div>
                        <!-- Checkmark Icon -->
                        <svg
                          xmlns="http://www.w3.org/2000/svg"
                          width="24"
                          height="24"
                          viewBox="0 0 24 24"
                          fill="none"
                        >
                          <g id="Upload 3">
                            <path
                              id="icon"
                              d="M15 9L12 12M12 12L9 15M12 12L9 9M12 12L15 15M21 12C21 16.9706 16.9706 21 12 21C7.02944 21 3 16.9706 3 12C3 7.02944 7.02944 3 12 3C16.9706 3 21 7.02944 21 12Z"
                              stroke="#4CAF50"
                              stroke-width="1.6"
                              stroke-linecap="round"
                            />
                          </g>
                        </svg>
                      </div>
                      <!-- Static Progress Bar for Completed Uploads -->
                      <div class="relative flex items-center gap-2.5 py-1.5">
                        <div class="relative w-full h-2.5 overflow-hidden rounded-3xl bg-gray-100">
                          <div
                            role="progressbar"
                            aria-valuenow="100"
                            aria-valuemin="0"
                            aria-valuemax="100"
                            style="width: 100%"
                            class="flex h-full items-center justify-center bg-indigo-600 text-white rounded-3xl"
                          >
                          </div>
                        </div>
                        <span class="ml-2 bg-white rounded-full text-gray-800 text-xs font-medium flex justify-center items-center">
                          100%
                        </span>
                      </div>
                    </div>
                  <% end %>
                  <!-- Submit Button -->
                  <button
                    type="submit"
                    class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-blue-800 hover:bg-blue-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
                  >
                    Upload Photos
                  </button>
                </div>
              </form>
            </sl-card>
          <% 3 -> %>
            <!-- Step 3: Payment Info -->
            <div>Step 3: Payment Info</div>
        <% end %>
      </div>
    </main>
    """
  end

  defp presign_upload(entry, socket) do
    uploads = socket.assigns.uploads

    bucket = System.get_env("SPACES_NAME")
    key = "uploads/#{entry.client_name}"

    config = %{
      access_key_id: System.get_env("SPACES_ACCESS_KEY_ID"),
      secret_access_key: System.get_env("SPACES_SECRET_ACCESS_KEY"),
      region: System.get_env("SPACES_REGION")
    }

    {:ok, fields} =
      SimpleS3Upload.sign_form_upload(config, bucket,
        key: key,
        content_type: entry.client_type,
        max_file_size: uploads[entry.upload_config].max_file_size,
        expires_in: :timer.hours(1)
      )

    meta = %{
      uploader: "S3",
      key: key,
      url: "https://#{bucket}.#{config.region}.digitaloceanspaces.com",
      fields: fields
    }

    {:ok, meta, socket}
  end

  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    if current_user do
      draft_post = Post.Query.get_draft_post_for_user(current_user.id)

      {changeset, current_step} =
        if draft_post do
          {Post.changeset(draft_post, %{}), draft_post.current_step}
        else
          {Post.changeset(%Post{user_id: current_user.id}, %{}), 1}
        end

      socket =
        socket
        |> assign(:form, to_form(changeset, as: "post"))
        |> assign(:current_user, current_user)
        |> assign(:current_step, current_step)
        |> assign(:uploaded_files, [])
        |> allow_upload(:images,
          accept: ~w(.jpg .jpeg .png .webp),
          max_entries: 8
        )

      # external: &presign_upload/2

      {:ok, socket}
    else
      {:ok, socket}
    end
  end

  def handle_event("toggle_shipping", _, socket) do
    current_value = socket.assigns.form[:shipping].value

    changeset =
      socket.assigns.form.source
      |> Post.changeset(%{shipping: !current_value})

    {:noreply, assign(socket, form: to_form(changeset, as: "post"))}
  end

  def handle_event("validate", %{"_target" => ["images"]}, socket) do
    {:noreply, socket}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("advance_to_step_2", %{"post" => post_params}, socket) do
    user = socket.assigns.current_user
    current_step = socket.assigns.current_step

    draft_post = socket.assigns.form.source.data

    post_params =
      post_params
      |> Map.put("user_id", user.id)
      |> Map.put("current_step", current_step + 1)

    changeset =
      Post.changeset(draft_post, post_params)
      |> Map.put(:action, :insert)

    if changeset.valid? do
      result =
        if draft_post.id do
          Post.Query.update_post(changeset)
        else
          Post.Query.create_post(post_params)
        end

      case result do
        {:ok, post} ->
          {:noreply,
           socket
           |> assign(:current_step, post.current_step)
           |> assign(:form, to_form(Post.changeset(post, %{}), as: "post"))}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, form: to_form(changeset, as: "post"))}
      end
    else
      {:noreply, assign(socket, form: to_form(changeset, as: "post"))}
    end
  end

  def handle_event("save", _params, socket) do
    post = socket.assigns.form.source.data

    case consume_uploaded_entries(socket, :images, fn %{path: path} = _entry, _entry ->
           bucket = System.get_env("SPACES_NAME")
           region = System.get_env("SPACES_REGION")

           url =
             "https://#{bucket}.#{region}.digitaloceanspaces.com/uploads/#{Path.basename(path)}"

           {:ok, url}
         end) do
      {:ok, uploaded_urls} ->
        changeset =
          post
          |> Post.changeset(%{photos: Enum.map(uploaded_urls, &%{url: &1})})
          |> Map.put(:action, :update)

        case GuitarAndBassExchange.Post.Query.update_post(changeset) do
          {:ok, updated_post} ->
            {:noreply,
             socket
             |> assign(:current_step, updated_post.current_step)
             |> assign(:form, to_form(Post.changeset(updated_post, %{}), as: "post"))
             |> assign(:uploaded_files, uploaded_urls)}

          {:error, changeset} ->
            Logger.error("Failed to update post: #{inspect(changeset.errors)}")
            {:noreply, assign(socket, form: to_form(changeset, as: "post"))}
        end

      {:error, reason} ->
        Logger.error("Failed to consume uploaded entries: #{inspect(reason)}")
        {:noreply, put_flash(socket, :error, "Failed to upload images")}
    end
  end
end