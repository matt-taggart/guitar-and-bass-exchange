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

export default Hooks;
