defmodule GuitarAndBassExchangeWeb.UserPostInstrument.Components.StepTwo do
  use Phoenix.Component
  import GuitarAndBassExchangeWeb.CoreComponents

  attr :uploads, :map, required: true
  attr :show_progress, :boolean, required: true
  attr :primary_photo, :integer, default: 0
  attr :total_progress, :integer, default: 0

  def render(assigns) do
    ~H"""
    <div>
      <.header class="text-center mb-8">
        Photos
        <:subtitle>
          Select up to 8 photos of the instrument you're posting. Photos should be less than 10MB.
        </:subtitle>
      </.header>

      <form id="upload-form" phx-submit="save" phx-change="validate" class="flex flex-col gap-2">
        <div class="w-full grid gap-5">
          <!-- Upload Container -->
          <.upload_container uploads={@uploads} />
          <!-- Display Upload Entries with Progress Bars -->
          <.photo_grid
            uploads={@uploads}
            primary_photo={@primary_photo}
            show_progress={@show_progress}
          />
          <!-- Progress Bar -->
          <.progress_bar :if={@show_progress} total_progress={@total_progress} />
          <!-- Submit Button -->
          <.submit_button uploads={@uploads} show_progress={@show_progress} />
        </div>
      </form>

      <%= for err <- upload_errors(@uploads.photos) do %>
        <p class="alert alert-danger"><%= error_to_string(err) %></p>
      <% end %>
    </div>
    """
  end

  defp upload_container(assigns) do
    ~H"""
    <div
      class="w-full py-20 bg-gray-50 rounded-2xl border border-gray-300 border-dashed mb-5"
      phx-drop-target={@uploads.photos.ref}
    >
      <div class="grid gap-3">
        <!-- Upload Instructions -->
        <div>
          <svg
            class="mx-auto mb-1"
            width="40"
            height="40"
            viewBox="0 0 40 40"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              d="M31.6497 10.6056L32.2476 10.0741L31.6497 10.6056ZM28.6559 7.23757L28.058 7.76907L28.058 7.76907L28.6559 7.23757ZM26.5356 5.29253L26.2079 6.02233L26.2079 6.02233L26.5356 5.29253ZM33.1161 12.5827L32.3683 12.867V12.867L33.1161 12.5827ZM31.8692 33.5355L32.4349 34.1012L31.8692 33.5355ZM24.231 11.4836L25.0157 11.3276L24.231 11.4836ZM26.85 14.1026L26.694 14.8872L26.85 14.1026ZM11.667 20.8667C11.2252 20.8667 10.867 21.2248 10.867 21.6667C10.867 22.1085 11.2252 22.4667 11.667 22.4667V20.8667ZM25.0003 22.4667C25.4422 22.4667 25.8003 22.1085 25.8003 21.6667C25.8003 21.2248 25.4422 20.8667 25.0003 20.8667V22.4667ZM11.667 25.8667C11.2252 25.8667 10.867 26.2248 10.867 26.6667C10.867 27.1085 11.2252 27.4667 11.667 27.4667V25.8667ZM20.0003 27.4667C20.4422 27.4667 20.8003 27.1085 20.8003 26.6667C20.8003 26.2248 20.4422 25.8667 20.0003 25.8667V27.4667ZM23.3337 34.2H16.667V35.8H23.3337V34.2Z"
              fill="#4F46E5"
            />
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
              <.live_file_input upload={@uploads.photos} hidden />
              <div class="flex w-28 h-9 px-2 flex-col bg-blue-600 rounded-full shadow text-white text-xs font-semibold leading-4 items-center justify-center cursor-pointer focus:outline-none">
                Choose File
              </div>
            </label>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp photo_grid(assigns) do
    ~H"""
    <div class={[
      "grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4",
      length(@uploads.photos.entries) > 0 && "mb-5"
    ]}>
      <%= for {entry, index} <- Enum.with_index(@uploads.photos.entries) do %>
        <div class="flex flex-col gap-1 relative">
          <div class="relative cursor-pointer" phx-click="show_preview" phx-value-ref={entry.ref}>
            <figure class="aspect-square overflow-hidden rounded-lg">
              <.live_img_preview entry={entry} class="w-full h-full object-cover" />
            </figure>
          </div>
          <.remove_button
            entry_ref={entry.ref}
            disabled={@uploads.photos.entries == [] || @show_progress}
          />
          <%= if index == @primary_photo do %>
            <sl-badge color="primary" class="primary-photo">
              Primary Photo
            </sl-badge>
          <% else %>
            <sl-button size="small" phx-click="set_primary_photo" phx-value-primary={index}>
              Make Primary
            </sl-button>
          <% end %>
        </div>
        <%= for err <- upload_errors(@uploads.photos, entry) do %>
          <p class="alert alert-danger"><%= error_to_string(err) %></p>
        <% end %>
      <% end %>
    </div>
    """
  end

  defp remove_button(assigns) do
    ~H"""
    <button
      type="button"
      aria-label="remove photo"
      phx-submit="prevent_default"
      phx-click="remove_photo"
      phx-value-ref={@entry_ref}
      disabled={@disabled}
      class="flex items-center justify-center p-1 text-xs font-medium rounded-full text-red-400 bg-transparent focus:outline-none focus:ring-1 focus:ring-offset-1 focus:ring-red-500 hover:text-red-500 hover:border-red-500 w-[28px] h-[28px] absolute right-px top-px z-50 transition-all duration-200 ease-in-out"
    >
      <.icon name="hero-trash-solid" class="h-4 w-4" />
    </button>
    """
  end

  defp progress_bar(assigns) do
    ~H"""
    <div class="w-full grid gap-5">
      <div class="w-full grid gap-4">
        <div class="w-full grid gap-1">
          <div class="flex items-center justify-between gap-2">
            <div class="flex items-center gap-2">
              <div class="grid gap-1">
                <h5 class="text-gray-400 text-sm font-normal font-['Inter'] leading-[18px]">
                  Uploading...
                </h5>
              </div>
            </div>
          </div>
          <div class="relative flex items-center gap-2.5 py-1.5">
            <div class="relative w-full h-2.5 overflow-hidden rounded-3xl bg-gray-100">
              <div
                role="progressbar"
                aria-valuenow={@total_progress}
                aria-valuemin="0"
                aria-valuemax="100"
                style={"width: #{@total_progress}%"}
                class="flex h-full items-center justify-center bg-indigo-600 text-white rounded-3xl"
              >
              </div>
            </div>
            <span class="ml-2 bg-white rounded-full text-gray-800 text-xs font-medium flex justify-center items-center">
              <%= @total_progress %>%
            </span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp submit_button(assigns) do
    ~H"""
    <div class="flex justify-end">
      <button
        type="submit"
        disabled={@uploads.photos.entries == [] || @show_progress}
        phx-disable-with="Uploading Photos..."
        class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:bg-gray-400 disabled:cursor-not-allowed"
      >
        Next Step
      </button>
    </div>
    """
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
end
