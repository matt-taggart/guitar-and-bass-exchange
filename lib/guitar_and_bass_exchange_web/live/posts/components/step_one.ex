defmodule GuitarAndBassExchangeWeb.UserPostInstrument.Components.StepOne do
  use Phoenix.Component
  import GuitarAndBassExchangeWeb.CoreComponents
  alias Countries

  attr :form, :map, required: true
  attr :uploads, :map, required: true

  def render(assigns) do
    ~H"""
    <div>
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
          <.input type="select" options={year_options()} field={@form[:year]} label="Year" required />
          <.input field={@form[:color]} label="Color" required />
          <.input
            variant="country_select"
            field={@form[:country_built]}
            label="Country Built"
            options={country_options()}
            required
          />
          <.input
            type="number"
            min="1"
            field={@form[:number_of_strings]}
            label="Number of Strings"
            required
          />
          <.input
            id="trix-input"
            type="trix"
            field={@form[:description]}
            label="Description"
            required
          />
          <.input
            type="select"
            options={condition_options()}
            field={@form[:condition]}
            label="Condition"
            required
          />
          <.input
            type="number"
            step="0.01"
            min="0"
            field={@form[:price]}
            label="Price"
            placeholder="$0.00"
            required
          />
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
              Next Step
            </.button>
          </:actions>
        </.simple_form>
      </sl-card>
    </div>
    """
  end

  defp year_options do
    Enum.to_list(1950..Date.utc_today().year)
    |> Enum.reverse()
  end

  defp country_options do
    Countries.all()
    |> Enum.sort_by(& &1.name)
    |> Enum.map(fn country -> {country.name, country.alpha2} end)
  end

  defp condition_options do
    ["New", "Excellent", "Good", "Fair", "Poor"]
  end
end
