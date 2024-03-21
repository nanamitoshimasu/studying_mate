import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "modal", "modalTime", "shareLink"]

   connect() {
    console.log("Stimulus controller connected");
   // The ID of the background to hide/remove
    this.backgroundId = this.data.get('backgroundId') || 'modal-background'
    console.log("backgroundId:", this.backgroundId);
    
    // The HTML for the background element
    this.backgroundHtml =
      this.data.get('backgroundHtml') || this._backgroundHTML()
    console.log("backgroundHtml:", this.backgroundHtml);
  }

  disconnect() {
    this.modalClose()
  }

  submitForm(event) {
    event.preventDefault();
    const formData = new FormData(this.formTarget); // ここでフォームデータを取得

    fetch(this.formTarget.action, { // ここでフォームのアクション（サーバーエンドポイント）にリクエストを送信
        method: 'POST',
        body: formData,
        headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
    })
    .then(response => response.json())
    .then(data => this.editEnd(data)) // レスポンスデータをeditEndメソッドに渡す
    .catch(error => console.error('エラー:', error));
  }

  // レスポンス処理（editEndメソッド）
  editEnd(data) {
    // ここにレスポンスデータを処理するコードを記述
    if (data.status === "success") {
      // 成功時の処理
      const duration = data.calculated_time;
      const hours = Math.floor(duration / 3600);
      const minutes = Math.floor((duration % 3600) / 60);
      this.modalTimeTarget.textContent = `${String(hours).padStart(2, '0')}時間${String(minutes).padStart(2, '0')}分`;
      const shareText = `えっへん！学習時間${hours}時間${minutes}分の森林を増やしました！`;
      const rootUrl = "http://www.yaruki-morimori.com";
      const shareUrl = `https://twitter.com/intent/tweet?url=${encodeURIComponent(rootUrl)}&text=${encodeURIComponent(shareText)}%0A&hashtags=やる気の森&hashtags=やるもり&hashtags=yarukimorimori`;
      // シェアリンクターゲットのhref属性を更新
      this.shareLinkTarget.setAttribute("href", shareUrl);

      this.modalTarget.classList.remove("hidden");
    } else {
        // 失敗時の処理
        this.showFlashMessage("編集できませんでした");
    }
  }

  showFlashMessage(message) {
    // 既存のフラッシュメッセージ非表示タイマーをクリアする
    clearTimeout(this.flashMessageTimeout);
  
    this.flashMessageTarget.textContent = message;
    this.flashMessageTarget.classList.remove('hidden');

    // 3秒後にフラッシュメッセージを非表示にする
    this.flashMessageTimeout = setTimeout(() => {
    this.flashMessageTarget.classList.add('hidden');
    }, 3000);
  }
 
  modalOpen(e) {
    // Lock the scroll and save current scroll position
    this.lockScroll()

    // Unhide the modal
    this.modalTarget.classList.remove('hidden');

    // Insert the background
    if (!this.data.get('disable-backdrop')) {
      document.body.insertAdjacentHTML('beforeend', this.backgroundHtml)
      this.background = document.querySelector(`#${this.backgroundId}`)
    }
  }

  modalClose(e) {
    console.log("Modal close triggered");
    if (e) e.preventDefault();
    
    if (this.modalTarget) {
      this.modalTarget.classList.add('hidden');
      // Unlock the scroll and restore previous scroll position
      this.unlockScroll()
    } 
    // Remove the background
    if (this.background) {
      this.background.remove()
    }
  }
  _backgroundHTML() {
    return `<div id="${this.backgroundId}" class="fixed top-0 left-0 w-full h-full" style="background-color: rgba(0, 0, 0, 0.8); z-index: 9998;"></div>`
  }

  lockScroll() {
    // Add right padding to the body so the page doesn't shift
    // when we disable scrolling
    const scrollbarWidth =
      window.innerWidth - document.documentElement.clientWidth
    document.body.style.paddingRight = `${scrollbarWidth}px`

    // Save the scroll position
    this.saveScrollPosition()

    // Add classes to body to fix its position
    document.body.classList.add('fixed', 'inset-x-0', 'overflow-hidden')

    // Add negative top position in order for body to stay in place
    document.body.style.top = `-${this.scrollPosition}px`
  }
  
  unlockScroll() {
    // Remove tweaks for scrollbar
    document.body.style.paddingRight = null

    // Remove classes from body to unfix position
    document.body.classList.remove('fixed', 'inset-x-0', 'overflow-hidden')

    // Restore the scroll position of the body before it got locked
    this.restoreScrollPosition()

    // Remove the negative top inline style from body
    document.body.style.top = null
  } 

  saveScrollPosition() {
    this.scrollPosition = window.pageYOffset || document.body.scrollTop
  }

  restoreScrollPosition() {
    document.documentElement.scrollTop = this.scrollPosition
  }
}
