import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "dots"]

  connect() {
    if (this.contentTarget.textContent.trim().length > 0) {
      this.markAnswered()
      return
    }

    this.observer = new MutationObserver(() => this.checkContent())
    this.observer.observe(this.contentTarget, { childList: true, characterData: true, subtree: true })
  }

  disconnect() {
    this.observer?.disconnect()
  }

  checkContent() {
    if (this.contentTarget.textContent.trim().length > 0) this.markAnswered()
  }

  markAnswered() {
    this.observer?.disconnect()
    if (this.hasDotsTarget) this.dotsTarget.remove()
  }
}
