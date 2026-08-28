import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["current"]

  connect() {
    if (!this.hasCurrentTarget) return

    requestAnimationFrame(() => {
      this.currentTarget.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" })
      this.currentTarget.focus({ preventScroll: true })
    })
  }
}
