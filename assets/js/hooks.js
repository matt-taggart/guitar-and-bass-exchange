let Hooks = {};

Hooks.ImagePreview = {
  mounted() {
    this.el.addEventListener("change", (event) => {
      let input = event.target;
      if (input.files && input.files[0]) {
        let reader = new FileReader();
        reader.onload = (e) => {
          let preview = this.el.parentElement.querySelector(".image-preview");
          if (preview) {
            preview.src = e.target.result;
          }
        };
        reader.readAsDataURL(input.files[0]);
      }
    });
  },
};

Hooks.StripeCheckout = {
  mounted() {
    const stripe = Stripe(window.ENV.stripePublishableKey);
    let elements;
    let paymentElement;

    this.handleEvent("checkout", ({ clientSecret }) => {
      // Clear any existing elements
      const cardElement = document.querySelector("#card-element");
      cardElement.innerHTML = "";

      // Create elements instance
      elements = stripe.elements({
        clientSecret,
        appearance: {
          theme: "stripe",
          variables: {
            colorPrimary: "#0070f3",
          },
        },
      });

      // Create and mount the payment element
      paymentElement = elements.create("payment");
      paymentElement.mount("#card-element");
      cardElement.classList.remove("hidden");

      // Get the button and disable initially
      const button = document.querySelector("[data-promote-button]");
      button.disabled = true;

      // Enable/disable button based on form completion
      paymentElement.on("change", (event) => {
        if (event.complete) {
          button.disabled = false;
          this.pushEvent("stripe_form_complete", {});
        } else {
          button.disabled = true;
          this.pushEvent("stripe_form_incomplete", {});
        }
      });
    });

    // Handle form submission
    window.handleStripeSubmit = async () => {
      const button = document.querySelector("[data-promote-button]");
      button.disabled = true;
      this.pushEvent("payment_processing", {}); // Start loading state

      const { error } = await stripe.confirmPayment({
        elements,
        confirmParams: {
          return_url: `${window.location.origin}/checkout/success`,
        },
      });

      if (error) {
        const errorDiv = document.getElementById("card-errors");
        errorDiv.textContent = error.message;
        button.disabled = false;
        this.pushEvent("payment_failed", {}); // Remove loading state
      }
    };
  },
};

export default Hooks;
