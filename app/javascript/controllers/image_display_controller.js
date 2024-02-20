import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "display"]

  display() {
    const selectedValue = this.selectTarget.value;
    const imageUrl = document.getElementById(`#image-option-${selectedValue}`).dataset.url;
    this.displayTarget.src = imageUrl;
  }
}
