// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import Hooks from "./hooks.js";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

// In assets/js/app.js or your custom JS file

// Initialize Stripe
const stripe = Stripe(window.ENV.stripePublishableKey);
let elements;
let card;
let paymentElement;

// Listen for the custom event from LiveView
window.addEventListener("phx:begin-payment", (e) => {
  const { clientSecret } = e.detail;

  // Create elements instance if it doesn't exist
  if (!elements) {
    elements = stripe.elements({ clientSecret });
  }

  // Create and mount the payment element if it doesn't exist
  if (!paymentElement) {
    paymentElement = elements.create("payment");
    paymentElement.mount("#card-element");

    // Show the card element container
    document.querySelector("#card-element").classList.remove("hidden");
  }

  // Handle the payment
  stripe
    .confirmPayment({
      elements,
      confirmParams: {
        return_url: `${window.location.origin}/checkout/success`,
      },
    })
    .then(function (result) {
      if (result.error) {
        // Handle error
        const errorDiv = document.getElementById("card-errors");
        errorDiv.textContent = result.error.message;
      } else {
        // Payment successful
        // The page will redirect to your return_url
      }
    });
});
