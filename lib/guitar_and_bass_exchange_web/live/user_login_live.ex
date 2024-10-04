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
          <div>
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
