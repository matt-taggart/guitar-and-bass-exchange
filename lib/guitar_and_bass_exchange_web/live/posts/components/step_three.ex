defmodule GuitarAndBassExchangeWeb.UserPostInstrument.Components.StepThree do
  use Phoenix.Component

  @min_promotion_amount 1.00

  attr :form, :map, required: true
  attr :photos, :list, required: true
  attr :preview_url, :string, default: nil
  attr :preview_entry, :any, default: nil
  attr :promotion_type, :string, required: true
  attr :promotion_amount, :float, required: true
  attr :checkout_form, :map, required: true
  attr :stripe_form_complete, :boolean, required: true
  attr :stripe_form_in_progress, :boolean, required: true
  attr :payment_processing, :boolean, required: true
  attr :payment_intent_id, :string, default: nil
  attr :min_promotion_amount, :float, default: 1.00

  def render(assigns) do
    assigns = assign(assigns, :min_promotion_amount, @min_promotion_amount)

    ~H"""
    <div class="space-y-8">
      <.progress_summary />
      <.instrument_preview_card form={@form} photos={@photos} />
      <.promotion_card
        promotion_type={@promotion_type}
        promotion_amount={@promotion_amount}
        checkout_form={@checkout_form}
        stripe_form_complete={@stripe_form_complete}
        stripe_form_in_progress={@stripe_form_in_progress}
        payment_processing={@payment_processing}
        payment_intent_id={@payment_intent_id}
        min_promotion_amount={@min_promotion_amount}
      />
    </div>
    """
  end

  defp progress_summary(assigns) do
    ~H"""
    <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
      <div class="flex items-center justify-between">
        <h2 class="text-2xl font-bold text-gray-900">Almost Done!</h2>
        <div class="flex items-center space-x-2">
          <.progress_step text="Review Details" active={true} />
          <span class="text-gray-300">→</span>
          <.progress_step text="Choose Promotion" active={true} />
          <span class="text-gray-300">→</span>
          <.progress_step text="Publish" active={false} />
        </div>
      </div>
    </div>
    """
  end

  defp progress_step(assigns) do
    ~H"""
    <div class="flex items-center">
      <div class={[
        "w-2.5 h-2.5 rounded-full mr-2",
        @active && "bg-blue-600",
        !@active && "bg-gray-300"
      ]}>
      </div>
      <span class="text-sm text-gray-600"><%= @text %></span>
    </div>
    """
  end

  defp instrument_preview_card(assigns) do
    ~H"""
    <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
      <!-- Primary Photo Display -->
      <div class="relative aspect-video bg-gray-100">
        <%= if length(@photos) > 0 do %>
          <img
            src={Enum.find(@photos, &(&1.id == &1.post.primary_photo_id)).url}
            alt="Primary instrument photo"
            class="w-full h-full object-cover"
          />
        <% else %>
          <div class="flex items-center justify-center h-full">
            <p class="text-gray-400">No photos uploaded</p>
          </div>
        <% end %>

        <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
        <div class="absolute bottom-0 left-0 right-0 p-6">
          <h1 class="text-3xl font-bold text-white mb-2"><%= @form[:title].value %></h1>
          <div class="flex items-center space-x-4">
            <span class="text-2xl font-bold text-white">
              $<%= :erlang.float_to_binary(@form[:price].value || 0.0, decimals: 2) %>
            </span>
            <%= if @form[:shipping].value do %>
              <span class="px-3 py-1 rounded-full bg-green-500/20 text-green-100 text-sm">
                Shipping Available
              </span>
            <% end %>
          </div>
        </div>
      </div>
      <!-- Photo Gallery -->
      <.photo_gallery photos={@photos} />
      <!-- Details Grid -->
      <.details_grid form={@form} />
    </div>
    """
  end

  defp photo_gallery(assigns) do
    ~H"""
    <div class="p-6 border-b border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">Photos</h3>
      <div class="grid grid-cols-2 sm:grid-cols-4 gap-4">
        <%= for photo <- Enum.filter(@photos, &(&1.id != &1.post.primary_photo_id)) do %>
          <div class="relative group rounded-lg overflow-hidden bg-gray-100 aspect-square">
            <img
              src={photo.url}
              alt="Instrument photo"
              class="w-full h-full object-cover transition duration-300 cursor-pointer hover:opacity-75"
              phx-click="show_stored_preview"
              phx-value-url={photo.url}
            />
            <%= if photo.id == photo.post.primary_photo_id do %>
              <div class="absolute top-2 right-2">
                <span class="bg-blue-600 text-white text-xs px-2 py-1 rounded-full font-medium shadow-sm">
                  Primary
                </span>
              </div>
            <% end %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp details_grid(assigns) do
    ~H"""
    <div class="p-6 grid grid-cols-1 md:grid-cols-2 gap-6 md:gap-24">
      <!-- Basic Info -->
      <div class="space-y-4">
        <h3 class="text-lg font-semibold text-gray-900">Basic Information</h3>
        <dl class="space-y-2">
          <.detail_row label="Brand" value={@form[:brand].value} />
          <.detail_row label="Model" value={@form[:model].value} />
          <.detail_row label="Year" value={@form[:year].value} />
          <.detail_row label="Color" value={@form[:color].value} />
          <.detail_row label="Country Built" value={@form[:country_built].value} />
        </dl>
      </div>
      <!-- Specifications -->
      <div class="space-y-4">
        <h3 class="text-lg font-semibold text-gray-900">Specifications</h3>
        <dl class="space-y-2">
          <.detail_row label="Number of Strings" value={@form[:number_of_strings].value} />
          <.detail_row label="Condition" value={@form[:condition].value} />
          <%= if @form[:shipping].value do %>
            <.detail_row
              label="Shipping Cost"
              value={"$#{:erlang.float_to_binary(@form[:shipping_cost].value || 0.0, decimals: 2)}"}
            />
          <% end %>
        </dl>
      </div>
    </div>
    <div class="p-6 md:col-span-2 space-y-4">
      <h3 class="text-lg font-semibold text-gray-900">Description</h3>
      <p class="text-gray-600 whitespace-pre-wrap"><%= @form[:description].value %></p>
    </div>
    """
  end

  defp detail_row(assigns) do
    ~H"""
    <div class="flex justify-between">
      <dt class="text-gray-500"><%= @label %></dt>
      <dd class="text-gray-900 font-medium"><%= @value %></dd>
    </div>
    """
  end

  defp promotion_card(assigns) do
    ~H"""
    <div class="bg-gradient-to-br from-blue-50 to-indigo-50 rounded-xl p-8 border border-blue-100">
      <div class="max-w-2xl mx-auto">
        <div class="flex items-start space-x-4">
          <div class="flex-shrink-0 mt-1">
            <div class="p-2 bg-blue-600 rounded-lg">
              <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M13 10V3L4 14h7v7l9-11h-7z"
                />
              </svg>
            </div>
          </div>
          <div class="flex-1">
            <h2 class="text-xl font-bold text-gray-900 mb-2">
              Boost Your Listing's Visibility
            </h2>
            <p class="text-gray-600 mb-6">
              Want to sell faster? Promote your instrument to stand out in our Featured section. Your promotion amount determines your visibility – higher amounts mean better placement on our homepage. For fairness, we randomly rotate listings that share the same promotion level. The more you promote, the more potential buyers will see your instrument.
            </p>
            <div class="grid gap-4 mb-8">
              <label class="relative flex items-start p-4 cursor-pointer bg-white rounded-lg border border-gray-200 hover:border-blue-500 transition-colors">
                <div class="flex items-center h-5">
                  <input
                    type="radio"
                    name="promotion_type"
                    value="basic"
                    checked={@promotion_type == "basic"}
                    phx-click="set_promotion_type"
                    phx-value-type="basic"
                    class="h-4 w-4 text-blue-600 border-gray-300 focus:ring-blue-500"
                  />
                </div>
                <div class="ml-3">
                  <span class="block text-sm font-medium text-gray-900">Basic Promotion</span>
                </div>
                <span class="ml-auto font-medium text-gray-900">$5</span>
              </label>

              <label class="relative flex items-start p-4 cursor-pointer bg-white rounded-lg border border-gray-200 hover:border-blue-500 transition-colors">
                <div class="flex items-center h-5">
                  <input
                    type="radio"
                    name="promotion_type"
                    value="premium"
                    checked={@promotion_type == "premium"}
                    phx-click="set_promotion_type"
                    phx-value-type="premium"
                    class="h-4 w-4 text-blue-600 border-gray-300 focus:ring-blue-500"
                  />
                </div>
                <div class="ml-3">
                  <span class="block text-sm font-medium text-gray-900">Premium Promotion</span>
                </div>
                <span class="ml-auto font-medium text-gray-900">$10</span>
              </label>

              <label class="relative flex items-start p-4 cursor-pointer bg-white rounded-lg border border-gray-200 hover:border-blue-500 transition-colors">
                <div class="flex items-center h-5">
                  <input
                    type="radio"
                    name="promotion_type"
                    value="custom"
                    checked={@promotion_type == "custom"}
                    phx-click="set_promotion_type"
                    phx-value-type="custom"
                    class="h-4 w-4 text-blue-600 border-gray-300 focus:ring-blue-500"
                  />
                </div>
                <div class="ml-3">
                  <span class="block text-sm font-medium text-gray-900">Custom Amount</span>
                  <span class="block text-sm text-gray-500">
                    Enter your own promotion amount (minimum $1.00)
                  </span>
                </div>
                <div class="ml-auto">
                  <input
                    type="number"
                    min={@min_promotion_amount}
                    step="0.01"
                    value={
                      if @promotion_type == "custom",
                        do: format_amount(@promotion_amount),
                        else: format_amount(@min_promotion_amount)
                    }
                    placeholder="1.00"
                    class="w-24 text-right rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                    phx-blur="set_custom_amount"
                    phx-change="validate_promotion_amount"
                    disabled={@promotion_type != "custom"}
                  />
                  <%= if @promotion_type == "custom" && @promotion_amount < @min_promotion_amount do %>
                    <div class="text-red-500 text-sm mt-1">
                      Minimum promotion amount is $<%= format_amount(@min_promotion_amount) %>
                    </div>
                  <% end %>
                </div>
              </label>
            </div>
            <div class="grid gap-4">
              <div class="contents">
                <div id="stripe-container" phx-update="ignore">
                  <div
                    id="stripe-checkout-card"
                    phx-hook="StripeCheckout"
                    class="min-h-[150px] bg-white p-4 rounded-lg shadow hidden"
                  >
                    <!-- Stripe Elements will insert the card element here -->
                  </div>
                  <div id="card-errors" role="alert" class="mt-2 text-red-600 text-sm"></div>
                </div>

                <.promotion_buttons
                  checkout_form={@checkout_form}
                  promotion_type={@promotion_type}
                  promotion_amount={@promotion_amount}
                  stripe_form_complete={@stripe_form_complete}
                  stripe_form_in_progress={@stripe_form_in_progress}
                  payment_processing={@payment_processing}
                  payment_intent_id={@payment_intent_id}
                  min_promotion_amount={@min_promotion_amount}
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp get_button_copy(payment_intent_id, stripe_form_complete, payment_processing) do
    case {payment_intent_id, stripe_form_complete, payment_processing} do
      {nil, false, false} -> "Pay and Promote"
      {_, false, false} -> "Complete Promotion"
      {_, _, true} -> "Processing..."
      _ -> "Pay and Promote"
    end
  end

  defp is_button_disabled?(payment_intent_id, stripe_form_complete, payment_processing) do
    case {payment_intent_id, stripe_form_complete, payment_processing} do
      {true, false, false} -> "Pay and Promote"
      {true, true, false} -> "Complete Promotion"
      {_, _, true} -> "Processing..."
      _ -> "Pay and Promote"
    end
  end

  defp promotion_buttons(assigns) do
    ~H"""
    <div class="flex flex-col sm:flex-row gap-4">
      <button
        type="button"
        disabled={@payment_processing || (@payment_intent_id && !@stripe_form_complete)}
        id="handle_stripe_submit"
        phx-hook="HandleStripeSubmit"
        phx-click={if @payment_intent_id, do: "handle_payment", else: "promote_listing"}
        class="flex-1 bg-blue-600 text-white px-6 py-3 rounded-lg text-sm font-semibold hover:bg-blue-700 transition duration-150 focus:ring-4 focus:ring-blue-200 disabled:bg-gray-400 disabled:cursor-not-allowed relative"
      >
        <%= cond do %>
          <% @payment_processing -> %>
            Processing...
          <% @payment_intent_id -> %>
            Complete Payment
          <% true -> %>
            Pay $<%= format_amount(@promotion_amount) %> and Promote
        <% end %>
        <%= if @payment_processing do %>
          <div class="absolute inset-0 flex items-center justify-center">
            <!-- spinner SVG -->
          </div>
        <% end %>
      </button>

      <button
        type="button"
        phx-click="publish_without_promotion"
        class="flex-1 bg-white text-gray-700 px-6 py-3 rounded-lg text-sm font-semibold hover:bg-gray-50 transition duration-150 focus:ring-4 focus:ring-gray-200 border border-gray-200"
      >
        Publish Without Promotion
      </button>
    </div>
    """
  end

  # Add this helper function to handle nil values
  defp format_amount(nil), do: "0.00"

  defp format_amount(amount) when is_float(amount) do
    :erlang.float_to_binary(amount, decimals: 2)
  end

  defp format_amount(amount) when is_binary(amount) do
    case Float.parse(amount) do
      {float, _} -> format_amount(float)
      :error -> "0.00"
    end
  end

  defp format_amount(_), do: "0.00"
end
