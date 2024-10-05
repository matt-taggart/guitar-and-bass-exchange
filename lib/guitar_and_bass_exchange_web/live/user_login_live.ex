defmodule GuitarAndBassExchangeWeb.UserLoginLive do
  use GuitarAndBassExchangeWeb, :live_view

  def render(assigns) do
    ~H"""
    <div style="
      background-image: url('https://images.unsplash.com/photo-1593698054498-56898cbad8af?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D');
      background-size: cover;
      background-position: center;
      background-repeat: no-repeat;
      width: 100vw;
      height: 100vh;
    ">
      <.link href={~p"/"}>
        <div class="text-white text-xl fixed top-7 left-7">Guitar and Bass Exchange</div>
      </.link>
      <main class="flex items-center justify-center h-screen px-8 py-8">
        <sl-card class="lg:w-2/5 md:w-2/3 sm:w-2/3 xs:2/3">
          <h1 class="text-3xl text-center mb-[-1rem]">Sign In</h1>
          <.simple_form
            for={@form}
            id="login_form"
            action={~p"/users/log_in"}
            phx-update="ignore"
            class="mx-4 my-4"
          >
            <.input field={@form[:email]} type="email" label="Email" required />
            <.input field={@form[:password]} type="password" label="Password" required />

            <:actions>
              <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
              <.link class="text-blue-500 hover:underline text-sm" href={~p"/users/reset_password"}>
                Forgot Password?
              </.link>
            </:actions>
            <:actions>
              <.button
                phx-disable-with="Logging in..."
                class="w-full text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 focus:outline-none"
              >
                Sign In <span aria-hidden="true">→</span>
              </.button>
            </:actions>
          </.simple_form>
          <div class="relative flex items-center justify-center bg-white mt-8 mb-2">
            <div class="border-b border-gray-200 w-full"></div>
            <span class="absolute bg-white px-2 text-gray-500">or</span>
          </div>
          <div class="mb-3 mx-4">
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
                Sign in with Google
              </button>
            </.link>
          </div>
          <div class="px-4 text-gray-500">
            Don't have an account?
            <.link class="text-blue-500 hover:underline" href={~p"/users/register"}>Sign Up</.link>
          </div>
        </sl-card>
      </main>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
