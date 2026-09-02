import { Controller } from "@hotwired/stimulus"

// This nav-bar icon is Clem's hiding spot: click it and she ninja-vanishes
// into it; click again and she pops back out. Purely a show/hide toggle —
// mascot-controller (elsewhere on the page) does the actual animating and
// reports back via "clem:hidden-state" so this icon can light up (like any
// other active nav item) while she's tucked away in here.
export default class extends Controller {
  connect() {
    this.onHiddenState = this.onHiddenState.bind(this)
    document.addEventListener("clem:hidden-state", this.onHiddenState)
  }

  disconnect() {
    document.removeEventListener("clem:hidden-state", this.onHiddenState)
  }

  toggle(event) {
    event.preventDefault()
    document.dispatchEvent(new CustomEvent("clem:toggle-hidden"))
  }

  onHiddenState(event) {
    this.element.classList.toggle("active", event.detail.hidden)
  }
}
