import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    images: Array
  }

  connect() {
    if (document.body.classList.contains("background-image")) {
      this.loadBackground();
      this.startTransitonInterval();
    }
  }

  disconnect() {
    this.restBackground();
    if(this.interval) {
      cleanInterval(this.interval);
    }
  }

  startTransitonInterval() {
    this.interval = setInterval(() => {
      this.loadBackground();
    }, 5000);
  }

  loadBackground() {
    // ランダムに画像を選択
    const randomImage = this.imagesValue[Math.floor(Math.random() * this.imagesValue.length)];

    // 既存のスタイル要素があれば削除
    const existingStyle = document.getElementById("dynamic-bg-style");
    if (existingStyle) {
      existingStyle.remove();
    }

    // 新しいスタイル要素を作成してbodyの背景画像を設定
    const style = document.createElement("style");
    style.id = "dynamic-bg-style";
    style.innerHTML = `
      body::before {
        content: "";
        position: fixed;
        top: 0;
        right: 0;
        bottom: 0;
        left: 0;
        z-index: -1;
        background-image: url('${randomImage}');
        background-repeat: no-repeat;
        background-size: cover;
        background-position: center;
        opacity: 0.5;
        animation: image-switch-animation 5s infinite;
      }
    `;

    document.head.appendChild(style);
  }

  resetBackground() {
    const existingStyle = document.getElementById("dynamic-bg-style");
    if (existingStyle) {
      existingStyle.remove();
    }
  }
}
