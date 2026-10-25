import { Controller } from "@hotwired/stimulus"

// Clem's body language: her eyes (and head) track the cursor anywhere on the
// page, and — only on the launcher blob, which now doubles as the deployed
// panel's header (there's only ever one Clem on screen) — she goofs around
// when nobody's talked to her in a while: a little shrug of a gesture every
// so often, juggling once she's gone IDLE_JUGGLE_MS untouched, and if she's
// really been ignored for IDLE_SLEEP_MS she dozes off until something wakes
// her back up.
const IDLE_JUGGLE_MS = 30000
const IDLE_SLEEP_MS = 60000
const IDLE_GESTURE_MIN_MS = 12000
const IDLE_GESTURE_MAX_MS = 22000
const TICK_MS = 1000

const GESTURE_DURATION_MS = {
  scratching: 1800,
  "filing-nails": 2250,
  yawning: 1600,
  eating: 2600,
  whistling: 3600,
  "six-seven": 3200,
  juggling: 6000,
}

// "sleeping" is sustained rather than timed — see wakeUp(). "vanishing" is
// also sustained (she stays hidden until toggled back) — see hide()/reappear().
const IDLE_GESTURES = ["scratching", "filing-nails", "yawning", "eating", "whistling", "six-seven"]

const VANISH_MS = 3200
const APPEAR_MS = 900

// Survives Turbo navigation (but not a fresh tab/browser restart) — clicking
// her nav-bar icon should keep her tucked away as you move between pages,
// not just until the next page loads her fresh.
const HIDDEN_STORAGE_KEY = "clemHidden"

// A different exit every time — one is picked at random whenever she's
// hidden. Each has its own chat-widget--vanish-<name> CSS (keyframes +
// props/particles in _claim_blob.html.erb), all sharing the same portal
// travel mechanic (see updatePortalOffset) and VANISH_MS duration.
const VANISH_VARIANTS = ["ninja", "pinball", "rocket", "ufo", "bubble", "magic", "bat"]

export default class extends Controller {
  static targets = ["blob", "face", "pupil"]

  connect() {
    this.onMouseMove = this.onMouseMove.bind(this)
    this.onInteraction = this.onInteraction.bind(this)
    this.onToggleHidden = this.onToggleHidden.bind(this)

    document.addEventListener("mousemove", this.onMouseMove, { passive: true })
    this.element.addEventListener("pointerdown", this.onInteraction)
    this.element.addEventListener("keydown", this.onInteraction)
    this.element.addEventListener("input", this.onInteraction)
    document.addEventListener("clem:toggle-hidden", this.onToggleHidden)

    this.currentGesture = null
    this.gestureTimeout = null
    this.isHidden = sessionStorage.getItem(HIDDEN_STORAGE_KEY) === "1"
    this.isAnimating = false
    this.registerInteraction()
    this.scheduleNextIdleGesture()
    this.tickTimer = setInterval(() => this.evaluateIdleState(), TICK_MS)

    if (this.isHidden) {
      this.element.classList.add("chat-widget--vanished")
      document.dispatchEvent(new CustomEvent("clem:hidden-state", { detail: { hidden: true } }))
    }
  }

  disconnect() {
    document.removeEventListener("mousemove", this.onMouseMove)
    this.element.removeEventListener("pointerdown", this.onInteraction)
    this.element.removeEventListener("keydown", this.onInteraction)
    this.element.removeEventListener("input", this.onInteraction)
    document.removeEventListener("clem:toggle-hidden", this.onToggleHidden)
    clearInterval(this.tickTimer)
    clearTimeout(this.gestureTimeout)
  }

  // Her nav-bar lookalike (nav_clem_portal_controller) dispatches this on
  // every click — she ninja-vanishes into it, or pops back out, in turn.
  // isAnimating guards mid-transition double-clicks; it's deliberately
  // separate from currentGesture, which is only ever an idle gesture name —
  // evaluateIdleState() checks isHidden directly so gestures can't sneak in
  // (or get frozen mid-pose) while she's tucked away.
  onToggleHidden() {
    if (this.isAnimating) return

    this.isHidden ? this.reappear() : this.hide()
  }

  hide() {
    this.isAnimating = true
    this.isHidden = true
    sessionStorage.setItem(HIDDEN_STORAGE_KEY, "1")
    clearTimeout(this.gestureTimeout)
    Object.keys(GESTURE_DURATION_MS).concat("sleeping").forEach((name) => {
      this.element.classList.remove(`chat-widget--${name}`)
    })
    this.currentGesture = null
    this.updatePortalOffset()

    this.vanishVariant = VANISH_VARIANTS[Math.floor(Math.random() * VANISH_VARIANTS.length)]
    this.element.classList.remove("chat-widget--appearing")
    this.element.classList.add("chat-widget--vanishing", `chat-widget--vanish-${this.vanishVariant}`)
    document.dispatchEvent(new CustomEvent("clem:hidden-state", { detail: { hidden: true } }))

    this.gestureTimeout = setTimeout(() => {
      this.isAnimating = false
    }, VANISH_MS)
  }

  reappear() {
    this.isAnimating = true
    this.isHidden = false
    sessionStorage.setItem(HIDDEN_STORAGE_KEY, "0")
    this.updatePortalOffset()
    this.element.classList.remove("chat-widget--vanishing", "chat-widget--vanished")
    VANISH_VARIANTS.forEach((name) => this.element.classList.remove(`chat-widget--vanish-${name}`))
    this.element.classList.add("chat-widget--appearing")
    document.dispatchEvent(new CustomEvent("clem:hidden-state", { detail: { hidden: false } }))
    this.registerInteraction()

    this.gestureTimeout = setTimeout(() => {
      this.element.classList.remove("chat-widget--appearing")
      this.isAnimating = false
      // She reappeared via her nav-bar icon, not the launcher itself — open
      // the chat panel for her rather than making them click a second time.
      document.dispatchEvent(new CustomEvent("clem:open-panel"))
    }, APPEAR_MS)
  }

  // Measures the real on-screen distance between the launcher and her
  // nav-bar lookalike so the vanish/appear keyframes (chat-mascot-vanish/
  // -appear) can travel there and back rather than just shrinking in place.
  updatePortalOffset() {
    const navIcon = document.querySelector(".nav-icon-link--clem")
    const blob = this.blobTargets.find((b) => b.closest(".chat-widget__launcher"))
    if (!navIcon || !blob) return

    const navRect = navIcon.getBoundingClientRect()
    const blobRect = blob.getBoundingClientRect()
    if (!navRect.width || !blobRect.width) return

    const dx = (navRect.left + navRect.width / 2) - (blobRect.left + blobRect.width / 2)
    const dy = (navRect.top + navRect.height / 2) - (blobRect.top + blobRect.height / 2)
    blob.style.setProperty("--portal-dx", `${dx.toFixed(1)}px`)
    blob.style.setProperty("--portal-dy", `${dy.toFixed(1)}px`)

    // Viewport size, so the more acrobatic variants (bat, pinball, ...) can
    // swoop/bounce across a real fraction of the actual screen instead of a
    // few dozen pixels near the corner.
    blob.style.setProperty("--vp-w", `${window.innerWidth}px`)
    blob.style.setProperty("--vp-h", `${window.innerHeight}px`)
  }

  onInteraction() {
    this.registerInteraction()
  }

  registerInteraction() {
    this.lastInteractionAt = Date.now()
    this.nextJuggleAt = this.lastInteractionAt + IDLE_JUGGLE_MS
    if (this.currentGesture === "sleeping") this.wakeUp()
  }

  wakeUp() {
    this.element.classList.remove("chat-widget--sleeping")
    this.currentGesture = null
    this.scheduleNextIdleGesture()
  }

  scheduleNextIdleGesture() {
    const delay = IDLE_GESTURE_MIN_MS + Math.random() * (IDLE_GESTURE_MAX_MS - IDLE_GESTURE_MIN_MS)
    this.nextIdleGestureAt = Date.now() + delay
  }

  evaluateIdleState() {
    if (this.isHidden || this.isAnimating) return
    if (this.currentGesture) return
    if (this.element.classList.contains("chat-widget--thinking")) return

    const now = Date.now()
    const idleFor = now - this.lastInteractionAt

    if (idleFor >= IDLE_SLEEP_MS) {
      this.playSustainedGesture("sleeping")
      return
    }

    if (now >= this.nextJuggleAt) {
      this.nextJuggleAt = now + IDLE_JUGGLE_MS
      this.playGesture("juggling")
      return
    }

    if (now >= this.nextIdleGestureAt) {
      this.scheduleNextIdleGesture()
      const gesture = IDLE_GESTURES[Math.floor(Math.random() * IDLE_GESTURES.length)]
      this.playGesture(gesture)
    }
  }

  playGesture(name) {
    this.currentGesture = name
    this.element.classList.add(`chat-widget--${name}`)

    this.gestureTimeout = setTimeout(() => {
      this.element.classList.remove(`chat-widget--${name}`)
      this.currentGesture = null
    }, GESTURE_DURATION_MS[name])
  }

  playSustainedGesture(name) {
    this.currentGesture = name
    this.element.classList.add(`chat-widget--${name}`)
  }

  onMouseMove(event) {
    if (this.rafId) return

    const { clientX, clientY } = event
    this.rafId = requestAnimationFrame(() => {
      this.rafId = null
      this.updateGaze(clientX, clientY)
    })
  }

  updateGaze(x, y) {
    this.faceTargets.forEach((face) => {
      const rect = face.getBoundingClientRect()
      if (!rect.width) return

      const angle = this.angleTo(rect, x, y)
      const turn = Math.max(-14, Math.min(14, Math.cos(angle) * 14))
      face.style.setProperty("--head-turn", `${turn.toFixed(1)}deg`)
    })

    this.pupilTargets.forEach((pupil) => {
      const eye = pupil.parentElement
      const rect = eye.getBoundingClientRect()
      if (!rect.width) return

      const angle = this.angleTo(rect, x, y)
      const radius = rect.width * 0.2
      pupil.style.setProperty("--pupil-x", `${(Math.cos(angle) * radius).toFixed(1)}px`)
      pupil.style.setProperty("--pupil-y", `${(Math.sin(angle) * radius).toFixed(1)}px`)
    })
  }

  angleTo(rect, x, y) {
    const cx = rect.left + rect.width / 2
    const cy = rect.top + rect.height / 2
    return Math.atan2(y - cy, x - cx)
  }
}
