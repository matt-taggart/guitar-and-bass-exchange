defmodule GuitarAndBassExchangeWeb.UserRegistrationLive do
  use GuitarAndBassExchangeWeb, :live_view

  alias GuitarAndBassExchange.Accounts
  alias GuitarAndBassExchange.Accounts.User

  def render(assigns) do
    ~H"""
    <section class="bg-white">
      <div class="lg:grid lg:min-h-screen lg:grid-cols-12">
        <section class="relative flex h-32 items-end bg-gray-900 lg:col-span-5 lg:h-full xl:col-span-6">
          <img
            alt="Electric Jazz Guitar"
            src="https://images.unsplash.com/photo-1541991961-c16157c6f0e6?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
            class="absolute inset-0 h-full w-full object-cover opacity-80"
          />

          <div class="hidden lg:relative lg:block lg:p-12">
            <h2 class="mt-6 text-3xl font-bold text-white sm:text-3xl md:text-5xl">
              Welcome to Guitar and Bass Exchange
            </h2>

            <p class="mt-4 text-lg leading-relaxed text-white/90">
              Join now to start buying, selling, and trading in our trusted community of guitar and bass enthusiasts.
            </p>
          </div>
        </section>

        <main class="flex items-center justify-center px-8 py-8 sm:px-12 lg:col-span-7 lg:px-16 lg:py-12 xl:col-span-6">
          <div class="w-[calc(100%-8rem)]">
            <div class="relative block lg:hidden">
              <h1 class="my-2 text-2xl font-bold text-brand sm:text-3xl md:text-4xl">
                Welcome to Guitar and Bass Exchange
              </h1>

              <p class="mb-4 leading-relaxed text-gray-500 dark:text-gray-400">
                Join now to start buying, selling, and trading in our trusted community of guitar and bass enthusiasts.
              </p>
            </div>

            <div>
              <h1 class="text-3xl text-center">Sign Up</h1>
              <.simple_form
                for={@form}
                id="registration_form"
                phx-submit="save"
                phx-change="validate"
                phx-trigger-action={@trigger_submit}
                action={~p"/users/log_in?_action=registered"}
                method="post"
              >
                <.error :if={@check_errors}>
                  Oops, something went wrong! Please check the errors below.
                </.error>

                <.input field={@form[:email]} type="email" label="Email" required />
                <.input field={@form[:password]} type="password" label="Password" required />

                <:actions>
                  <.button
                    phx-disable-with="Creating account..."
                    class="w-full text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 focus:outline-none"
                  >
                    Create an account
                  </.button>
                </:actions>
              </.simple_form>
              <div class="relative flex items-center justify-center bg-white mt-8 mb-2">
                <div class="border-b border-gray-200 w-full"></div>
                <span class="absolute bg-white px-2 text-gray-500">or</span>
              </div>
              <.link href={~p"/auth/google"}>
                <button
                  type="button"
                  class="text-white bg-[#4285F4] hover:bg-[#4285F4]/90 focus:ring-4 focus:outline-none focus:ring-[#4285F4]/50 font-medium rounded-lg text-sm px-5 py-2.5 text-center inline-flex items-center justify-center dark:focus:ring-[#4285F4]/55 me-2 mb-2 mt-8 w-full"
                >
                  <svg
                    class="w-4 h-4 me-2"
                    aria-hidden="true"
                    xmlns="http://www.w3.org/2000/svg"
                    fill="currentColor"
                    viewBox="0 0 18 19"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M8.842 18.083a8.8 8.8 0 0 1-8.65-8.948 8.841 8.841 0 0 1 8.8-8.652h.153a8.464 8.464 0 0 1 5.7 2.257l-2.193 2.038A5.27 5.27 0 0 0 9.09 3.4a5.882 5.882 0 0 0-.2 11.76h.124a5.091 5.091 0 0 0 5.248-4.057L14.3 11H9V8h8.34c.066.543.095 1.09.088 1.636-.086 5.053-3.463 8.449-8.4 8.449l-.186-.002Z"
                      clip-rule="evenodd"
                    />
                  </svg>
                  Sign up with Google
                </button>
              </.link>
            </div>

            <div class="flex flex-col gap-12 mt-5">
              <div class="text-gray-500">
                Already have an account?
                <.link class="text-blue-500 hover:underline" href={~p"/users/log_in"}>Sign In</.link>
              </div>

              <div class="flex flex-col gap-2">
                <hr class="border-t border-gray-300" />

                <div class="text-gray-500 text-sm">
                  By signing up, you agree to our
                  <a class="text-blue-500 hover:underline" href="/terms">Terms of Service</a>
                  and <a class="text-blue-500 hover:underline" href="/privacy">Privacy Policy</a>.
                </div>
              </div>
            </div>

            <script type="module">
              const form = document.querySelector('.input-validation-type');

              // Wait for controls to be defined before attaching form listeners
              await Promise.all([
                customElements.whenDefined('sl-button'),
                customElements.whenDefined('sl-input')
              ]).then(() => {
                form.addEventListener('submit', event => {
                  event.preventDefault();
                  alert('All fields are valid!');
                });
              });
            </script>
          </div>
        </main>
      </div>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
