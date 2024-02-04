import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["remainingTime", "showGoalAchievedModal", "showGoalNotAchievedModal"]
  static values = { endDate: String }

  connect() {
    this.checkStatus()
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
    // this.preventDefaultActionOpening =
      // (this.data.get('preventDefaultActionOpening') || 'true') === 'true'
    // console.log("preventDefaultActionOpening:", this.preventDefaultActionOpening);
    
    // Prevent the default action of the clicked element (following a link for example) when closing the modal
    this.preventDefaultActionClosing =
      (this.data.get('preventDefaultActionClosing') || 'true') === 'true'
    console.log("preventDefaultActionClosing:", this.preventDefaultActionClosing);
  }

  disconnect() {
    this.modalClose()
  }

  checkStatus() {
    const remainingTime = parseInt(this.remainingTimeTarget.textContent)
    const endDate = new Date(this.endDateValue)
    const now = new Date()
    
    if (remainingTime <= 0) {
      this.showGoalAchievedModal()
    } else if (now > endDate) {
      this.showGoalNotAchievedModal()
    }
  }

  showGoalAchievedModal() {
    // Unhide the modal
    this.showGoalAchievedModalTarget.classList.remove(this.toggleClass)
    // Insert the background
    if (!this.data.get('disable-backdrop')) {
      document.body.insertAdjacentHTML('beforeend', this.backgroundHtml)
      this.background = document.querySelector(`#${this.backgroundId}`)
      // Lock the scroll and save current scroll position
      this.lockScroll()
    }
  }
  
  showGoalNotAchievedModal() {
    // Unhide the modal
    this.showGoalNotAchievedModalTarget.classList.remove(this.toggleClass)
    // Insert the background
    if (!this.data.get('disable-backdrop')) {
      document.body.insertAdjacentHTML('beforeend', this.backgroundHtml)
      this.background = document.querySelector(`#${this.backgroundId}`)
      // Lock the scroll and save current scroll position
      this.lockScroll()
    }
  }
  
  modalClose(e) {
    if (e && this.preventDefaultActionClosing) {
      e.preventDefault()
    }

    // Unlock the scroll and restore previous scroll position
    this.unlockScroll()

    // Hide the modal
    this.modalTarget.classList.add(this.toggleClass)

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
