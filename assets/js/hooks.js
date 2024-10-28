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
    });

    // Handle form submission
    window.handleStripeSubmit = async () => {
      const { error } = await stripe.confirmPayment({
        elements,
        confirmParams: {
          return_url: `${window.location.origin}/checkout/success`,
        },
      });

      if (error) {
        const errorDiv = document.getElementById("card-errors");
        errorDiv.textContent = error.message;
      }
    };
  },
};

export default Hooks;
