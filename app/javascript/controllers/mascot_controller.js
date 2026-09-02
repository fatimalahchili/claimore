import { Controller } from "@hotwired/stimulus"

// Clem's body language: her eyes (and head) track the cursor anywhere on the
// page, and — only on the launcher blob, so she doesn't upstage an active
// chat — she plays little idle gestures when nobody's talked to her:
// scratching her head every so often, and juggling once she's gone
// IDLE_JUGGLE_MS without being opened or messaged.
const IDLE_JUGGLE_MS = 30000
const IDLE_GESTURE_MIN_MS = 12000
const IDLE_GESTURE_MAX_MS = 22000
const TICK_MS = 1000

const GESTURE_DURATION_MS = {
  scratching: 1800,
  "filing-nails": 2250,
  juggling: 2400,
}

const IDLE_GESTURES = ["scratching", "filing-nails"]

export default class extends Controller {
  static targets = ["blob", "face", "pupil"]

  connect() {
    this.onMouseMove = this.onMouseMove.bind(this)
    this.onInteraction = this.onInteraction.bind(this)

    document.addEventListener("mousemove", this.onMouseMove, { passive: true })
    this.element.addEventListener("pointerdown", this.onInteraction)

    this.currentGesture = null
    this.gestureTimeout = null
    this.registerInteraction()
    this.scheduleNextIdleGesture()
    this.tickTimer = setInterval(() => this.evaluateIdleState(), TICK_MS)
  }

  disconnect() {
    document.removeEventListener("mousemove", this.onMouseMove)
    this.element.removeEventListener("pointerdown", this.onInteraction)
    clearInterval(this.tickTimer)
    clearTimeout(this.gestureTimeout)
  }

  onInteraction() {
    this.registerInteraction()
  }

  registerInteraction() {
    this.lastInteractionAt = Date.now()
    this.nextJuggleAt = this.lastInteractionAt + IDLE_JUGGLE_MS
  }

  scheduleNextIdleGesture() {
    const delay = IDLE_GESTURE_MIN_MS + Math.random() * (IDLE_GESTURE_MAX_MS - IDLE_GESTURE_MIN_MS)
    this.nextIdleGestureAt = Date.now() + delay
  }

  evaluateIdleState() {
    if (this.currentGesture) return
    if (this.element.classList.contains("chat-widget--open")) return

    const now = Date.now()

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
