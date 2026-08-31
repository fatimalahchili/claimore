import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  goBack(event) {
    if (window.history.length <= 1) return

    event.preventDefault()
    window.history.back()
  }
}
