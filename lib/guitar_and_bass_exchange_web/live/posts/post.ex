defmodule GuitarAndBassExchangeWeb.UserPostInstrumentLive do
  use GuitarAndBassExchangeWeb, :live_view

  alias GuitarAndBassExchange.{Post, Photo, Checkout}
  alias GuitarAndBassExchangeWeb.UserPostInstrument.{Components, Helpers}
  alias GuitarAndBassExchangeWeb.StripeHandler
  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <.flash_group id="checkout-flash-message" flash={@flash} />
    <.navbar current_user={@current_user} geocode_data={@geocode_data} />
    <main class="flex flex-col items-center my-16 mx-8">
      <div class="w-full max-w-6xl mx-auto">
        <%!-- Increased max width container --%>
        <ol class="flex flex-col sm:flex-row justify-between items-center text-sm font-medium text-center text-gray-500 sm:text-base max-w-2xl mx-auto mb-16">
          <%= for {heading, index} <- Helpers.list_headings() |> Enum.with_index() do %>
            <Components.ListHeading.render_list_heading
              heading={heading}
              is_active={@current_step == index + 1}
              step_number={index + 1}
              is_last={index == length(Helpers.list_headings()) - 1}
            />
          <% end %>
        </ol>

        <div class={
          [
            "w-full mx-auto",
            # Wider container for step 3
            @current_step == 3 && "max-w-4xl",
            # Original width for steps 1 and 2
            @current_step != 3 && "max-w-2xl"
          ]
        }>
          <%= case @current_step do %>
            <% 1 -> %>
              <Components.StepOne.render form={@form} uploads={@uploads} />
            <% 2 -> %>
              <Components.StepTwo.render
                uploads={@uploads}
                show_progress={@show_progress}
                primary_photo={@primary_photo}
                total_progress={@total_progress}
                show_preview={@show_preview}
                preview_entry={@preview_entry}
                preview_url={@preview_url}
              />
            <% 3 -> %>
              <Components.StepThree.render
                form={@form}
                photos={@photos}
                preview_url={@preview_url}
                preview_entry={@preview_entry}
                promotion_type={@promotion_type}
                checkout_form={@checkout_form}
                stripe_form_complete={@stripe_form_complete}
                stripe_form_in_progress={@stripe_form_in_progress}
                payment_processing={@payment_processing}
                payment_intent_id={@payment_intent_id}
                promotion_amount={@promotion_amount}
              />
          <% end %>
        </div>
      </div>
    </main>
    """
  end

  @impl true
  def mount(%{"post_id" => post_id}, session, socket) do
    current_user = socket.assigns.current_user

    action = socket.assigns.live_action

    socket =
      Helpers.prepare_initial_assigns(
        socket,
        current_user,
        post_id,
        action,
        session
      )

    {:ok, socket}
  end

  @impl true
  def mount(_params, session, socket) do
    current_user = socket.assigns.current_user

    if current_user do
      {:ok, Helpers.prepare_initial_assigns(socket, current_user, nil, false, session)}
    else
      {:ok, socket}
    end
  end

  @impl true
  def handle_event("show_preview", %{"ref" => entry_ref}, socket) do
    entry = Enum.find(socket.assigns.uploads.photos.entries, &(&1.ref == entry_ref))
    {:noreply, assign(socket, show_preview: true, preview_entry: entry, preview_url: nil)}
  end

  def handle_event("show_stored_preview", %{"url" => url}, socket) do
    {:noreply,
     socket
     |> assign(:show_preview, true)
     |> assign(:preview_entry, nil)
     |> assign(:preview_url, url)}
  end

  def handle_event("hide_preview", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_preview, false)
     |> assign(:preview_entry, nil)
     |> assign(:preview_url, nil)}
  end

  def handle_event("toggle_shipping", _, socket) do
    current_value = socket.assigns.form[:shipping].value
    changeset = Post.changeset(socket.assigns.form.source, %{shipping: !current_value})
    {:noreply, assign(socket, form: to_form(changeset, as: "post"))}
  end

  def handle_event("validate", params, socket) do
    case params do
      %{"_target" => ["photos"]} ->
        {:noreply, socket}

      %{"post" => post_params} ->
        changeset = Post.changeset(socket.assigns.form.source, post_params)
        {:noreply, assign(socket, form: to_form(changeset))}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event("remove_photo", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photos, ref) |> assign(primary_photo: 0)}
  end

  def handle_event("set_primary_photo", %{"primary" => index}, socket) do
    {:noreply, assign(socket, :primary_photo, String.to_integer(index))}
  end

  def handle_event("advance_to_step_2", %{"post" => post_params}, socket) do
    case handle_step_one_submission(socket, post_params) do
      {:ok, updated_socket} -> {:noreply, updated_socket}
      {:error, updated_socket} -> {:noreply, updated_socket}
    end
  end

  def handle_event("save", _params, socket) do
    case handle_step_two_submission(socket) do
      {:ok, updated_socket} -> {:noreply, updated_socket}
      {:error, updated_socket} -> {:noreply, updated_socket}
    end
  end

  def handle_event("promote_listing", _params, socket) do
    promotion_amount = socket.assigns.promotion_amount

    if Helpers.is_valid_promotion_amount?(socket.assigns.promotion_type, promotion_amount) do
      case StripeHandler.create_payment_intent(promotion_amount) do
        {:ok, %{client_secret: client_secret, id: id, amount: amount}} ->
          {:noreply,
           socket
           |> assign(:payment_intent_secret, client_secret)
           |> assign(:payment_intent_id, id)
           |> assign(:payment_intent_amount, amount)
           |> push_event("checkout", %{clientSecret: client_secret})}

        {:error, error} ->
          {:error,
           socket
           |> put_flash(:error, "Payment failed: #{error.message}")
           |> push_navigate(to: ~p"/")}
      end
    else
      {:error,
       socket
       |> put_flash(:error, "Please enter a valid promotion amount")}
    end
  end

  def handle_event("stripe_form_complete", _params, socket) do
    {:noreply, assign(socket, stripe_form_complete: true)}
  end

  def handle_event("stripe_form_incomplete", _params, socket) do
    {:noreply, assign(socket, stripe_form_complete: false)}
  end

  def handle_event("publish_without_promotion", _params, socket) do
    case publish_post(socket) do
      {:ok, updated_socket} -> {:noreply, updated_socket}
      {:error, updated_socket} -> {:noreply, updated_socket}
    end
  end

  def handle_event("prevent_default", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("handle_payment", _params, socket) do
    {:noreply, socket |> push_event("handle_stripe_submit", %{})}
  end

  def handle_event(
        "payment_succeeded",
        %{
          "payment_intent_id" => payment_intent_id,
          "payment_status" => status,
          "amount" => amount
        },
        socket
      ) do
    # Handle successful payment
    case handle_successful_payment(socket, payment_intent_id, status, amount) do
      {:ok, updated_socket} ->
        {:noreply,
         updated_socket
         |> assign(:payment_processing, false)
         |> put_flash(:info, "Post published successfully!")
         |> push_navigate(to: ~p"/users/#{socket.assigns.current_user.id}/posts")}

      {:error, reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "Payment processed but failed to update: #{reason}")
         |> assign(:payment_processing, false)}
    end
  end

  def handle_event("payment_failed", %{"error" => error_message}, socket) do
    {:noreply,
     socket
     |> put_flash(:error, "Payment failed: #{error_message}")
     |> assign(:payment_processing, false)}
  end

  def handle_event("set_promotion_type", %{"type" => type}, socket) do
    promotion_amount =
      case type do
        "basic" -> 5.00
        "premium" -> 10.00
        "custom" -> 1.00
        _ -> 5.00
      end

    {:noreply,
     socket
     |> assign(:promotion_type, type)
     |> assign(:promotion_amount, promotion_amount)}
  end

  def handle_event("set_custom_amount", %{"value" => value}, socket) do
    case Float.parse(value) do
      {amount, _} ->
        if amount >= 1.00 do
          {:noreply,
           socket
           |> assign(:promotion_type, "custom")
           |> assign(:promotion_amount, amount)}
        else
          {:noreply,
           socket
           |> assign(:promotion_amount, 1.00)
           |> assign(:promotion_type, "custom")
           |> put_flash(:error, "Minimum promotion amount is $1.00")}
        end

      :error ->
        {:noreply,
         socket
         |> assign(:promotion_amount, 1.00)
         |> assign(:promotion_type, "custom")}
    end
  end

  def handle_event("validate_promotion_amount", %{"value" => value}, socket) do
    case Float.parse(value) do
      {amount, _} ->
        {:noreply,
         socket
         |> assign(:promotion_amount, amount)}

      :error ->
        {:noreply, socket}
    end
  end

  def handle_event("payment_processing", _params, socket) do
    {:noreply, assign(socket, payment_processing: true)}
  end

  # Helper function to handle successful payment
  defp handle_successful_payment(socket, payment_intent_id, status, amount) do
    try do
      post = socket.assigns.form.source.data
      current_time = DateTime.utc_now()

      # Start a transaction to ensure both updates succeed or fail together
      Ecto.Multi.new()
      |> Ecto.Multi.update(
        :post,
        Post.changeset(post, %{
          status: :completed,
          featured: true,
          published_at: current_time
        })
      )
      |> Ecto.Multi.insert(:checkout, fn %{post: updated_post} ->
        Checkout.changeset(%Checkout{}, %{
          featured: true,
          # Convert from cents if needed
          promotion_amount: amount / 100,
          payment_intent_id: payment_intent_id,
          payment_status: status,
          published_at: current_time,
          post_id: updated_post.id
        })
      end)
      |> GuitarAndBassExchange.Repo.transaction()
      |> case do
        {:ok, %{post: updated_post, checkout: _checkout}} ->
          {:ok, assign(socket, :form, to_form(Post.changeset(updated_post, %{})))}

        {:error, :post, changeset, _} ->
          {:error, "Failed to update post: #{inspect(changeset.errors)}"}

        {:error, :checkout, changeset, _} ->
          {:error, "Failed to create checkout: #{inspect(changeset.errors)}"}
      end
    rescue
      e ->
        {:error, Exception.message(e)}
    end
  end

  # Private functions for handling step submissions

  defp handle_step_one_submission(socket, post_params) do
    user = socket.assigns.current_user
    current_step = socket.assigns.current_step
    draft_post = socket.assigns.form.source.data

    post_params =
      post_params
      |> Map.put("user_id", user.id)
      |> Map.put("current_step", 2)

    case Helpers.validate_step(post_params, current_step, draft_post) do
      {:ok, _} ->
        save_step_one(socket, post_params, draft_post)

      {:error, changeset} ->
        {:error, assign(socket, form: to_form(changeset, as: "post"))}
    end
  end

  defp save_step_one(socket, params, draft_post) do
    result =
      if draft_post.id do
        Post.Query.update_post(Post.changeset(draft_post, params))
      else
        Post.Query.create_post(params)
      end

    case result do
      {:ok, post} ->
        post = GuitarAndBassExchange.Repo.preload(post, [:photos, :primary_photo])

        {:ok,
         socket
         |> assign(:current_step, post.current_step)
         |> assign(:form, to_form(Post.changeset(post, %{}), as: "post"))}

      {:error, changeset} ->
        {:error, assign(socket, form: to_form(changeset, as: "post"))}
    end
  end

  defp handle_step_two_submission(socket) do
    post = socket.assigns.form.source.data
    primary_photo_index = socket.assigns.primary_photo

    case Helpers.process_uploads(socket, post.id) do
      {:ok, photos} ->
        handle_photo_creation_success(socket, post, photos, primary_photo_index)

      {:error, reason} ->
        {:error,
         socket
         |> put_flash(:error, "Failed to upload photos: #{reason}")
         |> assign(show_progress: false)}
    end
  end

  defp handle_photo_creation_success(socket, post, photos, primary_photo_index) do
    primary_photo = Enum.at(photos, primary_photo_index)

    changeset =
      post
      |> Post.changeset(%{
        current_step: 3,
        primary_photo_id: primary_photo.id
      })

    case Post.Query.update_post(changeset) do
      {:ok, updated_post} ->
        updated_post = GuitarAndBassExchange.Repo.preload(updated_post, [:photos, :primary_photo])

        photos =
          Photo.Query.list_photos_for_post(updated_post.id)
          # Convert Photo structs to maps
          |> Enum.map(&Map.from_struct/1)

        {:ok,
         socket
         |> assign(:form, to_form(Post.changeset(updated_post, %{}), as: "post"))
         |> assign(:current_step, updated_post.current_step)
         |> assign(:photos, photos)
         |> assign(:show_progress, false)
         |> put_flash(:info, "Successfully uploaded photos")}

      {:error, changeset} ->
        {:error,
         socket
         |> assign(:form, to_form(changeset, as: "post"))
         |> assign(:show_progress, false)
         |> put_flash(:error, "Failed to update post")}
    end
  end

  defp publish_post(socket) do
    post = socket.assigns.form.source.data

    current_time = DateTime.utc_now()

    changeset =
      post
      |> Post.changeset(%{status: :completed, featured: false, published_at: current_time})

    case Post.Query.update_post(changeset) do
      {:ok, _updated_post} ->
        {:ok,
         socket
         |> put_flash(:info, "Post published successfully!")
         |> push_navigate(to: ~p"/users/#{socket.assigns.current_user.id}/posts")}

      {:error, changeset} ->
        {:error,
         socket
         |> assign(form: to_form(changeset))
         |> put_flash(:error, "Failed to publish post")}
    end
  end
end
