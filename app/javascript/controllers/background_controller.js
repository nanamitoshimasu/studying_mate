import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["overlay"]
  static values = { images: Array }
  
  connect() {
      this.loadBackground();
      this.startTransitionInterval();
  }

  disconnect() {
    this.resetBackground();
    if (this.interval) {
      clearInterval(this.interval);
    }
  }

  startTransitionInterval() {
    this.interval = setInterval(() => {
      this.loadBackground();
    }, 5000);
  }

  loadBackground() {
    const randomIndex = Math.floor(Math.random() * this.imagesValue.length);
    const randomImage = this.imagesValue[randomIndex]; 
    
    // 新しい背景画像を設定
    this.overlayTarget.style.backgroundImage = `url(${randomImage})`;
    
    // 透明度の変更を行う前に短い遅延を設ける
    setTimeout(() => {
      this.overlayTarget.style.transition = 'opacity 1s ease-out';
      this.overlayTarget.style.opacity = 0;
      
      setTimeout(() => {
        // 透明度を1に戻してフェードイン
        this.overlayTarget.style.opacity = 1;
      }, 1); // 透明度を0に設定する操作の直後にフェードインを開始
    }, 1);
  }
}
