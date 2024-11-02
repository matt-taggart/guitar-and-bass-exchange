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

    // Store elements and paymentElement on the hook instance
    this.elements = null;
    this.paymentElement = null;

    this.handleEvent("checkout", ({ clientSecret }) => {
      const cardElement = document.querySelector("#stripe-checkout-card");
      if (!cardElement) return;

      cardElement.innerHTML = "";

      // Create new elements instance
      this.elements = stripe.elements({
        clientSecret,
        appearance: {
          theme: "stripe",
        },
      });

      // Create and mount payment element
      this.paymentElement = this.elements.create("payment");
      this.paymentElement.mount("#stripe-checkout-card");
      cardElement.classList.remove("hidden");

      // Add change handler
      this.paymentElement.on("change", (event) => {
        if (event.complete) {
          this.pushEvent("stripe_form_complete", {});
        } else {
          this.pushEvent("stripe_form_incomplete", {});
        }
      });

      // Handle form submission
      window.handleStripeSubmit = async () => {
        try {
          this.pushEvent("payment_processing", {});

          const { error, paymentIntent } = await stripe.confirmPayment({
            elements: this.elements,
            redirect: "if_required", // This prevents automatic redirect
            confirmParams: {
              return_url: `${window.location.origin}/checkout/success`, // Only used if 3D Secure is required
            },
          });

          if (error) {
            const errorDiv = document.getElementById("card-errors");
            errorDiv.textContent = error.message;
            this.pushEvent("payment_failed", { error: error.message });
          } else if (paymentIntent) {
            // Payment successful
            this.pushEvent("payment_succeeded", {
              payment_intent_id: paymentIntent.id,
              payment_status: paymentIntent.status,
              amount: paymentIntent.amount,
            });
          }
        } catch (err) {
          console.error("Payment failed:", err);
          this.pushEvent("payment_failed", { error: err.message });
        }
      };

      // Add unmounted callback
      return () => {
        if (this.paymentElement) {
          this.paymentElement.destroy();
        }

        delete window.handleStripeSubmit;
      };
    });
  },
};

Hooks.HandleStripeSubmit = {
  mounted() {
    this.handleEvent("handle_stripe_submit", () => {
      window.handleStripeSubmit();
    });
  },
};

export default Hooks;
