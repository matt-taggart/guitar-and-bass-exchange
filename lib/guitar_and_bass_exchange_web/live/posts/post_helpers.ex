defmodule GuitarAndBassExchangeWeb.UserPostInstrument.Helpers do
  require Logger

  # Add these imports
  import Phoenix.Component
  import Phoenix.LiveView
  import Ecto.Changeset
  import Phoenix.HTML.Form

  alias GuitarAndBassExchange.{Post, Photo}
  alias GuitarAndBassExchangeWeb.Plugs.FetchGeocodeData

  @doc """
  Returns a list of step headings for the instrument posting process.
  """
  def list_headings do
    [
      "Listing Info",
      "Upload Photos",
      "Promote and Submit"
    ]
  end

  @doc """
  Prepares assigns for Step One component.
  """
  def step_one_assigns(socket) do
    %{
      form: socket.assigns.form,
      uploads: socket.assigns.uploads
    }
  end

  @doc """
  Prepares assigns for Step Two component.
  """
  def step_two_assigns(socket) do
    %{
      uploads: socket.assigns.uploads,
      show_progress: socket.assigns.show_progress,
      primary_photo: socket.assigns.primary_photo,
      total_progress: socket.assigns.total_progress
    }
  end

  @doc """
  Prepares assigns for Step Three component.
  """
  def step_three_assigns(socket) do
    %{
      form: socket.assigns.form,
      photos: socket.assigns.photos,
      preview_url: socket.assigns.preview_url,
      preview_entry: socket.assigns.preview_entry,
      promotion_type: socket.assigns.promotion_type,
      checkout_form: socket.assigns.checkout_form,
      is_promoting: socket.assigns.is_promoting
    }
  end

  @doc """
  Validates a step based on current parameters
  """
  def validate_step(params, current_step, existing_post) do
    changeset = Post.changeset(existing_post, params)

    case current_step do
      1 ->
        validate_step_one(changeset)

      2 ->
        validate_step_two(changeset)

      3 ->
        validate_step_three(changeset)

      _ ->
        {:error, Ecto.Changeset.add_error(changeset, :step, "Invalid step")}
    end
  end

  # Validates step one - basic instrument information
  defp validate_step_one(changeset) do
    required_fields = [
      :title,
      :brand,
      :model,
      :year,
      :color,
      :country_built,
      :number_of_strings,
      :description,
      :condition,
      :price
    ]

    if all_fields_present?(changeset, required_fields) do
      {:ok, changeset}
    else
      {:error, add_missing_field_errors(changeset, required_fields)}
    end
  end

  # Validates step two - photo uploads
  defp validate_step_two(changeset) do
    # Step two validation primarily happens in the upload handlers
    # but you could add additional validation here if needed
    {:ok, changeset}
  end

  # Validates step three - promotion and submission
  defp validate_step_three(changeset) do
    if changeset.valid? do
      {:ok, changeset}
    else
      {:error, changeset}
    end
  end

  # Checks if all required fields are present in the changeset
  defp all_fields_present?(changeset, fields) do
    Enum.all?(fields, fn field ->
      value = Ecto.Changeset.get_field(changeset, field)
      value != nil && value != "" && value != []
    end)
  end

  # Adds error messages for missing required fields
  defp add_missing_field_errors(changeset, fields) do
    Enum.reduce(fields, changeset, fn field, acc ->
      value = Ecto.Changeset.get_field(acc, field)

      if value == nil || value == "" || value == [] do
        Ecto.Changeset.add_error(acc, field, "can't be blank")
      else
        acc
      end
    end)
  end

  # Additional validation helpers

  # Validates shipping cost when shipping is enabled
  defp validate_shipping_cost(changeset) do
    if Ecto.Changeset.get_field(changeset, :shipping) do
      shipping_cost = Ecto.Changeset.get_field(changeset, :shipping_cost)

      if shipping_cost && shipping_cost > 0 do
        changeset
      else
        Ecto.Changeset.add_error(
          changeset,
          :shipping_cost,
          "must be greater than 0 when shipping is enabled"
        )
      end
    else
      changeset
    end
  end

  # Validates price is within acceptable range
  defp validate_price(changeset) do
    price = Ecto.Changeset.get_field(changeset, :price)

    cond do
      price == nil ->
        Ecto.Changeset.add_error(changeset, :price, "can't be blank")

      price <= 0 ->
        Ecto.Changeset.add_error(changeset, :price, "must be greater than 0")

      price > 1_000_000 ->
        Ecto.Changeset.add_error(changeset, :price, "must be less than $1,000,000")

      true ->
        changeset
    end
  end

  # Validates year is within acceptable range
  defp validate_year(changeset) do
    year = Ecto.Changeset.get_field(changeset, :year)
    current_year = DateTime.utc_now().year

    cond do
      year == nil ->
        Ecto.Changeset.add_error(changeset, :year, "can't be blank")

      year < 1900 ->
        Ecto.Changeset.add_error(changeset, :year, "must be after 1900")

      year > current_year ->
        Ecto.Changeset.add_error(changeset, :year, "can't be in the future")

      true ->
        changeset
    end
  end

  @doc """
  Gets the default promotion amount for a promotion type
  """
  def get_default_promotion_amount(type) do
    case type do
      "basic" -> 5.00
      "premium" -> 10.00
      "custom" -> nil
      _ -> 5.00
    end
  end

  @doc """
  Validates if the promotion amount is valid for the given type
  """
  def is_valid_promotion_amount?(type, amount) do
    case type do
      "basic" -> amount == 5.00
      "premium" -> amount == 10.00
      "custom" -> amount != nil && amount > 0
      _ -> false
    end
  end

  @doc """
  Handles file upload progress tracking.
  Returns updated socket with progress information.
  """
  def handle_upload_progress(socket, entry) do
    if entry.done? do
      total_entries = length(socket.assigns.uploads.photos.entries)
      completed_entries = Enum.count(socket.assigns.uploads.photos.entries, & &1.done?)
      total_progress = floor(completed_entries / total_entries * 100)

      socket
      |> assign(:total_progress, total_progress)
      |> assign(:show_progress, true)
    else
      assign(socket, :show_progress, true)
    end
  end

  @doc """
  Processes uploaded files and creates photo records.
  Returns {:ok, photos} on success or {:error, reason} on failure.
  """
  def process_uploads(socket, post_id) do
    uploaded_urls =
      consume_uploaded_entries(socket, :photos, fn %{path: src_path}, entry ->
        handle_file_upload(src_path, entry)
      end)

    case process_upload_results(uploaded_urls) do
      {:ok, successful_urls} ->
        create_photo_records(successful_urls, post_id)

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp handle_file_upload(src_path, entry) do
    dest_path = "uploads/#{entry.client_name}"
    bucket = System.get_env("SPACES_NAME")
    region = System.get_env("SPACES_REGION")
    host = "#{bucket}.#{region}.cdn.digitaloceanspaces.com/#{bucket}"

    with {:ok, content} <- File.read(src_path),
         {:ok, _response} <- upload_to_s3(content, bucket, dest_path) do
      {:ok, "https://#{host}/#{dest_path}"}
    else
      error ->
        Logger.error("Upload failed: #{inspect(error)}")
        {:error, :upload_failed}
    end
  end

  defp upload_to_s3(content, bucket, dest_path) do
    operation = ExAws.S3.put_object(bucket, dest_path, content, acl: :public_read)

    case ExAws.request(operation) do
      {:ok, %{status_code: 200}} = response -> response
      error -> error
    end
  end

  defp process_upload_results(upload_results) do
    Enum.reduce_while(upload_results, {:ok, []}, fn
      {:ok, url}, {:ok, acc} ->
        {:cont, {:ok, [url | acc]}}

      {:error, _reason}, _acc ->
        {:halt, {:error, :upload_failed}}

      unexpected, _acc ->
        Logger.error("Unexpected upload result: #{inspect(unexpected)}")
        {:halt, {:error, :unexpected_result}}
    end)
  end

  defp create_photo_records(urls, post_id) do
    results =
      Enum.map(urls, fn url ->
        Photo.Query.create_photo(%{
          url: url,
          post_id: post_id
        })
      end)

    case Enum.split_with(results, fn
           {:ok, _} -> true
           _ -> false
         end) do
      {successes, []} ->
        {:ok, Enum.map(successes, fn {:ok, photo} -> photo end)}

      {_, failures} ->
        Logger.error("Failed to create some photos: #{inspect(failures)}")
        {:error, :photo_creation_failed}
    end
  end

  # Add the presign_upload function
  def presign_upload do
    bucket = System.get_env("SPACES_NAME")
    key = "uploads"
    opts = [virtual_host: true, bucket_as_host: true]
    {:ok, ExAws.Config.new(:s3) |> ExAws.S3.presigned_url(:put, bucket, key, opts)}
  end

  # Add the handle_progress function
  def handle_progress(:photos, entry, socket) do
    if entry.done? do
      total_entries = length(socket.assigns.uploads.photos.entries)
      completed_entries = Enum.count(socket.assigns.uploads.photos.entries, & &1.done?)
      total_progress = floor(completed_entries / total_entries * 100)
      {:noreply, assign(socket, total_progress: total_progress)}
    else
      {:noreply, socket}
    end
  end

  # Rest of your existing functions...
  # [Previous implementation continues...]

  @doc """
  Prepares socket assigns for mounting the LiveView.
  """
  def prepare_initial_assigns(socket, current_user, session) do
    draft_post = get_draft_post(current_user)
    {changeset, current_step} = get_initial_changeset(draft_post, current_user)
    photos = get_photos_for_step(draft_post, current_step)
    geocode_data = fetch_geocode_data(session)

    socket
    |> assign(:form, to_form(changeset, as: "post"))
    |> assign(:checkout_form, to_form(changeset, as: "checkout"))
    |> assign(:promotion_type, "basic")
    |> assign(:promotion_amount, "5.00")
    |> assign(:current_user, current_user)
    |> assign(:current_step, current_step)
    |> assign(:primary_photo, 0)
    |> assign(:uploaded_files, [])
    |> assign(:photos, photos)
    |> assign(:preview_upload, nil)
    |> assign(:preview_entry, nil)
    |> assign(:preview_url, nil)
    |> assign(:show_preview, false)
    |> assign(:is_promoting, false)
    |> assign(:is_loading_stripe, false)
    |> assign(:geocode_data, geocode_data)
    |> assign(:show_progress, false)
    |> assign(:total_progress, 0)
    |> allow_upload(:photos,
      accept: ~w(.jpg .jpeg .png .webp),
      max_entries: 8,
      temporary_assigns: [photos: []],
      presign_upload: &presign_upload/0,
      progress: &handle_progress/3
    )
  end

  defp get_draft_post(current_user) do
    Post.Query.get_draft_post_for_user(current_user.id)
  end

  defp get_initial_changeset(draft_post, current_user) do
    if draft_post do
      {Post.changeset(draft_post, %{}), draft_post.current_step}
    else
      {Post.changeset(%Post{user_id: current_user.id}, %{}), 1}
    end
  end

  defp get_photos_for_step(draft_post, current_step) do
    if current_step == 3 && draft_post && draft_post.id do
      Photo.Query.list_photos_for_post(draft_post.id)
    else
      []
    end
  end

  defp fetch_geocode_data(session) do
    FetchGeocodeData.fetch_geocode_data(session)
  end
end
