import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { images: Array }
  
  connect() {
    this.element.style.backgroundImage = `url(${this.randomImage()})`;
  }

  randomImage() {
    const randomIndex = Math.floor(Math.random() * this.imagesValue.length);
    return this.imagesValue[randomIndex];
  }
}
