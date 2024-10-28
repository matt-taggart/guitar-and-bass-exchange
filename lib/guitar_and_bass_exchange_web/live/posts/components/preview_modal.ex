# In components/preview_modal.ex

defmodule GuitarAndBassExchangeWeb.UserPostInstrument.Components.PreviewModal do
  use Phoenix.Component

  attr :preview_entry, :any, default: nil
  attr :preview_url, :string, default: nil
  attr :show_preview, :boolean, default: false

  def render(assigns) do
    ~H"""
    <div
      id="preview-modal"
      class="fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center z-[9999] !m-0 !p-0"
      phx-click="hide_preview"
      style="position: fixed; top: 0; left: 0;"
    >
      <div class="relative max-w-[90vw] max-h-[90vh]">
        <%= cond do %>
          <% @preview_entry -> %>
            <.live_img_preview entry={@preview_entry} class="max-w-full max-h-[85vh] object-contain" />
          <% @preview_url -> %>
            <img src={@preview_url} class="max-w-full max-h-[85vh] object-contain" />
          <% true -> %>
            <div class="text-white">No preview available</div>
        <% end %>
      </div>
    </div>
    """
  end
end
