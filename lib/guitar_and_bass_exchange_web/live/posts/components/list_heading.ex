defmodule GuitarAndBassExchangeWeb.UserPostInstrument.Components.ListHeading do
  use Phoenix.Component

  attr :is_active, :boolean, required: true
  attr :step_number, :integer, required: true
  attr :heading, :string, required: true
  attr :is_last, :boolean, required: true

  def render_list_heading(assigns) do
    ~H"""
    <li class={[
      "flex flex-col sm:flex-row items-center mb-6 sm:mb-0",
      @is_active && "text-blue-600 dark:text-blue-500"
    ]}>
      <span class="flex items-center space-x-2 whitespace-nowrap">
        <%= if @is_active do %>
          <svg
            class="w-3.5 h-3.5 sm:w-4 sm:h-4"
            aria-hidden="true"
            xmlns="http://www.w3.org/2000/svg"
            fill="currentColor"
            viewBox="0 0 20 20"
          >
            <path d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5Zm3.707 8.207-4 4a1 1 0 0 1-1.414 0l-2-2a1 1 0 0 1 1.414-1.414L9 10.586l3.293-3.293a1 1 0 0 1 1.414 1.414Z" />
          </svg>
        <% else %>
          <span class="font-semibold"><%= @step_number %></span>
        <% end %>
        <span><%= @heading %></span>
      </span>
      <!-- Separator (Only if not the last item) -->
      <%= if !@is_last do %>
        <div
          aria-hidden="true"
          class="hidden sm:block sm:w-[5rem] h-px bg-gray-400 sm:mx-[2rem] border-solid border border-gray-200"
        >
        </div>
      <% end %>
    </li>
    """
  end

  # Optional: Helper function to generate list headings data
  def list_headings do
    [
      %{heading: "Listing Info", step_number: 1},
      %{heading: "Upload Photos", step_number: 2},
      %{heading: "Promote and Submit", step_number: 3}
    ]
  end
end
