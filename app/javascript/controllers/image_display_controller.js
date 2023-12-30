import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "display"]

  display() {
    const selectedValue = this.selectTarget.value
    const imageUrl = this.getImageUrlFor(selectedValue)
    this.displayTarget.src = imageUrl
  }

  getImageUrlFor(value) {
    return `/assets/display_images/image-${value}.jpg`;
  }
}
