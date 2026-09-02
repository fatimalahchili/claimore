import { Controller } from "@hotwired/stimulus"

// The Administrations nav-bar icon doubles as a little portal: click it and
// the floating Clem' (mascot-controller, elsewhere on the page) vanishes in
// a puff of smoke before we navigate there, as if she ducked into it.
const VANISH_MS = 720

export default class extends Controller {
  static values = { url: String }

  vanish(event) {
    event.preventDefault()
    document.dispatchEvent(new CustomEvent("clem:vanish"))

    window.setTimeout(() => {
      if (window.Turbo) {
        window.Turbo.visit(this.urlValue)
      } else {
        window.location.href = this.urlValue
      }
    }, VANISH_MS)
  }
}
