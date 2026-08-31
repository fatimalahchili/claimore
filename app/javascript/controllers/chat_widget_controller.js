import { Controller } from "@hotwired/stimulus"

const STORAGE_KEY = "chatWidgetOpen"

export default class extends Controller {
  static targets = ["launcher", "panel", "body", "messages"]

  connect() {
    this.onKeydown = this.onKeydown.bind(this)
    this.onClickOutside = this.onClickOutside.bind(this)
    document.addEventListener("keydown", this.onKeydown)
    document.addEventListener("click", this.onClickOutside)

    this.observer = new MutationObserver(() => {
      this.scrollMessagesToBottom()
      this.updateThinkingState()
    })
    this.observer.observe(this.bodyTarget, { childList: true, subtree: true, characterData: true })
    this.updateThinkingState()

    if (sessionStorage.getItem(STORAGE_KEY) === "1") this.open()
  }

  disconnect() {
    document.removeEventListener("keydown", this.onKeydown)
    document.removeEventListener("click", this.onClickOutside)
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

  scrollMessagesToBottom() {
    if (!this.hasMessagesTarget) return

    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }

  updateThinkingState() {
    const thinking = this.bodyTarget.querySelector(".chat-bubble__typing") !== null
    this.element.classList.toggle("chat-widget--thinking", thinking)
  }
}
