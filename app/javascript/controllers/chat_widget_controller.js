import { Controller } from "@hotwired/stimulus"

const STORAGE_KEY = "chatWidgetOpen"
const CALLOUT_STORAGE_KEY = "chatWidgetCalloutSeen"

export default class extends Controller {
  static targets = ["launcher", "panel", "body", "messages", "callout"]

  connect() {
    this.onKeydown = this.onKeydown.bind(this)
    this.onClickOutside = this.onClickOutside.bind(this)
    this.onScroll = this.onScroll.bind(this)
    this.lastScrollY = window.scrollY
    document.addEventListener("keydown", this.onKeydown)
    document.addEventListener("click", this.onClickOutside)
    window.addEventListener("scroll", this.onScroll, { passive: true })

    this.observer = new MutationObserver(() => {
      this.scrollMessagesToBottom()
      this.updateThinkingState()
    })
    this.observer.observe(this.bodyTarget, { childList: true, subtree: true, characterData: true })
    this.updateThinkingState()

    if (localStorage.getItem(CALLOUT_STORAGE_KEY) === "1") this.hideCallout()
    if (sessionStorage.getItem(STORAGE_KEY) === "1") this.open()
  }

  disconnect() {
    document.removeEventListener("keydown", this.onKeydown)
    document.removeEventListener("click", this.onClickOutside)
    window.removeEventListener("scroll", this.onScroll)
    this.observer?.disconnect()
  }

  toggle() {
    this.isOpen ? this.close() : this.open()
  }

  open() {
    this.element.classList.add("chat-widget--open")
    this.panelTarget.setAttribute("aria-hidden", "false")
    this.launcherTarget.setAttribute("aria-expanded", "true")
    this.isOpen = true
    sessionStorage.setItem(STORAGE_KEY, "1")
    this.dismissCallout()
    this.scrollMessagesToBottom()

    const input = this.bodyTarget.querySelector(".chat-widget__input")
    if (input) requestAnimationFrame(() => input.focus())
  }

  close() {
    this.element.classList.remove("chat-widget--open")
    this.panelTarget.setAttribute("aria-hidden", "true")
    this.launcherTarget.setAttribute("aria-expanded", "false")
    this.isOpen = false
    sessionStorage.setItem(STORAGE_KEY, "0")
  }

  onKeydown(event) {
    if (event.key === "Escape" && this.isOpen) this.close()
  }

  onClickOutside(event) {
    if (this.isOpen && !this.element.contains(event.target)) this.close()
  }

  onScroll() {
    if (this.isOpen) return

    const currentScrollY = window.scrollY
    const scrollingDown = currentScrollY > this.lastScrollY && currentScrollY > 80
    this.element.classList.toggle("chat-widget--page-scrolled", scrollingDown)
    this.lastScrollY = currentScrollY
  }

  scrollMessagesToBottom() {
    if (!this.hasMessagesTarget) return

    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }

  updateThinkingState() {
    const thinking = this.bodyTarget.querySelector(".chat-bubble__typing") !== null
    this.element.classList.toggle("chat-widget--thinking", thinking)
  }

  dismissCallout() {
    localStorage.setItem(CALLOUT_STORAGE_KEY, "1")
    this.hideCallout()
  }

  hideCallout() {
    if (!this.hasCalloutTarget) return

    this.calloutTarget.classList.add("chat-widget__callout--hidden")
  }
}
