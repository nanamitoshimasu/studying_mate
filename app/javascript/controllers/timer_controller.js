// app/javascript/controllers/timer_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hours", "minutes", "seconds", "pauseResumeButton", "modalTime", "flashMessage", "modal", "shareLink", "bg"]
  static values = { teamId: Number, timerId: Number, breakTimeId: Number}
  timerStarted = false;
  
  initialize() {
    this.timerInterval = null;
    this.totalSeconds = 0;
    this.isPaused = false; //タイマーの情報を追跡する変数
    this.flashMessageTimeout = null; // フラッシュメッセージのタイマー制御用
  }

  connect(){
    console.log(this.timerIdValue); //タイマーID
    console.log(this.breakTimeIdValue);
    console.log(this.teamIdValue);
        // The class we should toggle on the container
    this.toggleClass = this.data.get('class') || 'hidden'
    console.log("toggleClass:", this.toggleClass);
    // The ID of the background to hide/remove
    this.backgroundId = this.data.get('backgroundId') || 'modal-background'
    console.log("backgroundId:", this.backgroundId);
    
    // The HTML for the background element
    this.backgroundHtml =
      this.data.get('backgroundHtml') || this._backgroundHTML()
    console.log("backgroundHtml:", this.backgroundHtml);
    
    // Let the user close the modal by clicking on the background
    this.allowBackgroundClose =
      (this.data.get('allowBackgroundClose') || 'true') === 'true'
    console.log("allowBackgroundClose:", this.allowBackgroundClose);
    
    // Prevent the default action of the clicked element (following a link for example) when opening the modal
    this.preventDefaultActionOpening =
      (this.data.get('preventDefaultActionOpening') || 'true') === 'true'
    console.log("preventDefaultActionOpening:", this.preventDefaultActionOpening);
    
    // Prevent the default action of the clicked element (following a link for example) when closing the modal
    this.preventDefaultActionClosing =
      (this.data.get('preventDefaultActionClosing') || 'true') === 'true'
    console.log("preventDefaultActionClosing:", this.preventDefaultActionClosing);
    
    this.bgTarget.classList.remove(this.toggleClass)
  }

  disconnect() {
    this.modalClose()
  }

  start() {
    if (this.timerInterval) return; //すでにタイマーが起動していたら何もしない
    // サーバーにスタート時刻を送信
    fetch(`/teams/${this.teamIdValue}/timers`, { 
      method: 'POST',
      credentials: 'same-origin',
      headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': window.getCsrfToken()
      },        
    })
      .then(response => {
        if (response.ok) {
          return response.json();
        } else {
          throw new Error('サーバーエラーが発生しました');
        }
      })
      .then(data => {
        this.timerIdValue = data.timerId; // 取得したタイマーIDを保存
        this._startTimer(); // タイマー開始
        this.timerStarted = true; // タイマーが開始されたことを追跡   
        this.isPaused = false;
        this.showFlashMessage("勉強開始！がんばろう！");
      })
      .catch(error => {
        console.error('エラー:', error);
      });
  }

  togglePauseResume() {
    console.log("Toggle pause/resume called. Current state: ", this.isPaused);
    // タイマーが開始されていない場合、フラッシュメッセージを表示して処理を終了する
  if (!this.timerStarted || !this.timerIdValue) {
    this.showFlashMessage("スタートが押されていません！");
    return;
  }
  if (this.isPaused) {
    // タイマーが一時停止されていた場合、再開する
    // サーバーに再開時刻を送信(break_end_timeを更新)
    fetch(`/teams/${this.teamIdValue}/timers/${this.timerIdValue}/break_times/${this.breakTimeIdValue}`, { 
      method: 'PATCH',
      credentials: 'same-origin',
      headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': window.getCsrfToken()
      },  
    })
      .then(response => {
        if (response.ok) {
          return response.json();
        } else {
          throw new Error('サーバーエラーが発生しました');
        }
      })
      .then(data => {
        // タイマー再開
        this._resumeTimer();
        this.pauseResumeButtonTarget.textContent = 'ちょっと休憩';
        this.isPaused = false;
        this.showFlashMessage("勉強再開！がんばるぞ〜！");
      })
      .catch(error => {
        this.showFlashMessage(error.message);
      });

  } else {
    // タイマーが動作していた場合、一時停止する
    // サーバーに一時停止時刻を送信(break_start_timeの作成)
    fetch(`/teams/${this.teamIdValue}/timers/${this.timerIdValue}/break_times`, { 
      method: 'POST',
      credentials: 'same-origin',
      headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': window.getCsrfToken()
      },
    })
      .then(response => {
        if (response.ok) {
          return response.json();
        } else {
          throw new Error(data.error || 'エラーが発生しました');
        }
      })
      .then(data => {
        // タイマー停止
        this._pauseTimer();
        console.log("Fetched response: ", data);
        this.breakTimeIdValue = data.breakTimeId; // 取得したブレイクタイムIDを保存
        clearInterval(this.timerInterval);
        this.timerInterval = null;
        this.pauseResumeButtonTarget.textContent = '休憩おしまい';
        this.isPaused = true;
        this.showFlashMessage("休憩休憩！リフレッシュしよっと。");
      })
      .catch(error => {
        this.showFlashMessage(error.message);
      });
    }
  }
  
    end() {
    if (this.timerStarted) {
      // タイマーを停止
      clearInterval(this.timerInterval);
      this.timerInterval = null;
      // サーバーに終了時刻を送信(end_timeを更新)
      fetch(`/teams/${this.teamIdValue}/timers/${this.timerIdValue}`, { 
        method: 'PATCH',
        credentials: 'same-origin',
        headers: {
                  'Content-Type': 'application/json',
                  'X-CSRF-Token': window.getCsrfToken()
        },
      })
      .then(response => {
        if (response.ok) {
          return response.json();
        } else {
          throw new Error('サーバーエラーが発生しました');
        }
      })
      .then(data => {
        // タイマー表示をリセット
        this._resetTimer();
        // モーダルに時間を表示
        const duration = data.calculated_time;
        const hours = Math.floor(duration / 3600);
        const minutes = Math.floor((duration % 3600) / 60);
        // モーダルに時間を表示
        this.modalTimeTarget.textContent = `${String(hours).padStart(2, '0')}時間${String(minutes).padStart(2, '0')}分`;
        const shareText = `えっへん！学習時間${hours}時間${minutes}分の森林を増やしました！`;
        const rootUrl = "http://www.yaruki-morimori.com";
        const shareUrl = `https://twitter.com/intent/tweet?url=${encodeURIComponent(rootUrl)}&text=${encodeURIComponent(shareText)}%0A&hashtags=やる気の森&hashtags=やるもり&hashtags=yarukimorimori`;
        // シェアリンクターゲットのhref属性を更新
        this.shareLinkTarget.setAttribute("href", shareUrl);
        if (data.persisted) {
          console.log("Timer is persisted.");
        // 既存の編集ボタンを削除
        const existingEditButtons = document.querySelectorAll("#modal-button .btn-secondary");
        existingEditButtons.forEach(button => button.remove());

          const editButtonHTML = 
            `<a href="/teams/${this.teamIdValue}/timers/${this.timerIdValue}/edit_all_timestamps" class="btn btn-secondary">編集する</a>`;
          document.querySelector("#modal-button").insertAdjacentHTML('beforeend', editButtonHTML);
        }
      })
      .catch(error => {
        console.error('エラー:', error);
      });
    }

    else {
      // タイマーがまだ開始されていない場合、フラッシュメッセージを表示
      this.showFlashMessage("スタートが押されていません！");
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
    console.log(e)
    if (!this.timerStarted) {
    // タイマーが開始されていない場合、モーダルを開かない
    return;
    }
    else if (this.preventDefaultActionOpening) {
      e.preventDefault()
    }

    e.target.blur()

    // Lock the scroll and save current scroll position
    this.lockScroll()

    // Unhide the modal
    this.modalTarget.classList.remove(this.toggleClass)

    // Insert the background
    if (!this.data.get('disable-backdrop')) {
      document.body.insertAdjacentHTML('beforeend', this.backgroundHtml)
      this.background = document.querySelector(`#${this.backgroundId}`)
    }
  }
  
  modalClose(e) {
    if (e && this.preventDefaultActionClosing) {
      e.preventDefault()
    }

    // Unlock the scroll and restore previous scroll position
    this.unlockScroll()
    
    // Hide the start modal 
    if (this.bgTarget) {
      this.bgTarget.classList.add(this.toggleClass);
    } 

    // Hide the modal
    if (this.modalTarget) {
      this.modalTarget.classList.add(this.toggleClass);
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

   // プライベートメソッド
  _startTimer() {
    if (this.timerInterval) return;
    // タイマー開始時の時刻を記録
    if (!this.timerStarted) {
    this.startTime = Date.now();
    this.pausedTime = 0;
    this.lastPausedAt = 0;
    this.timerStarted = true;
    }

    this.timerInterval = setInterval(() => {
      const now = Date.now();
      // 現在時刻と開始時刻の差分を計算
      const elapsedTime = now - this.startTime - this.pausedTime; 

      // 経過時間を秒単位に変換
      this.totalSeconds = Math.floor(elapsedTime / 1000);

      // UIを更新
      const hours = Math.floor(this.totalSeconds / 3600);
      const minutes = Math.floor((this.totalSeconds % 3600) / 60);
      const seconds = this.totalSeconds % 60;
      this.hoursTarget.textContent = String(hours).padStart(2, '0');
      this.minutesTarget.textContent = String(minutes).padStart(2, '0');
      this.secondsTarget.textContent = String(seconds).padStart(2, '0');
    }, 1000);
  }
  
  _pauseTimer() {
    if(this.timerInterval) {
      clearInterval(this.timerInterval);
      this.timerInterval = null;
      this.lastPausedAt = Date.now();
    }
  }

  _resumeTimer() {
    if(!this.timerInterval && this.lastPausedAt) {
      this.pausedTime += Date.now() - this.lastPausedAt;
      this._startTimer();
    }
  }

  _resetTimer() {
    clearInterval(this.timerInterval); // タイマーを停止
    this.timerInterval = null; // タイマーIDをリセット
    this.totalSeconds = 0;
    this.hoursTarget.textContent = '00';
    this.minutesTarget.textContent = '00';
    this.secondsTarget.textContent = '00'; // 秒数もリセット
  }
}
