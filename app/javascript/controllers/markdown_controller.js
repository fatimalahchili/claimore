import { Controller } from "@hotwired/stimulus"

// Renders the lightweight Markdown Clem is instructed to write (bold, headings,
// lists, inline code) as real HTML. Re-runs on every mutation so it keeps up
// as the response streams in, then settles once streaming stops.
export default class extends Controller {
  connect() {
    this.observer = new MutationObserver(() => this.handleMutation())
    this.lastRaw = this.element.textContent
    this.render()
    this.observer.observe(this.element, { childList: true, characterData: true, subtree: true })
  }

  disconnect() {
    this.observer?.disconnect()
  }

  handleMutation() {
    const raw = this.element.textContent
    if (raw === this.lastRaw) return

    this.lastRaw = raw
    this.render()
  }

  render() {
    this.element.innerHTML = renderMarkdown(this.lastRaw)
    this.observer.takeRecords()
  }
}

function escapeHtml(text) {
  return text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;")
}

function renderInline(text) {
  return escapeHtml(text)
    .replace(/`([^`]+)`/g, "<code>$1</code>")
    .replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>")
    .replace(/(?<!\*)\*([^*]+)\*(?!\*)/g, "<em>$1</em>")
    .replace(/(?<!_)_([^_]+)_(?!_)/g, "<em>$1</em>")
}

function renderBlock(block) {
  const lines = block.split("\n").filter((line) => line.length > 0)
  if (lines.length === 0) return ""

  if (lines.every((line) => /^[-*]\s+/.test(line))) {
    const items = lines.map((line) => `<li>${renderInline(line.replace(/^[-*]\s+/, ""))}</li>`).join("")
    return `<ul>${items}</ul>`
  }

  if (lines.every((line) => /^\d+\.\s+/.test(line))) {
    const items = lines.map((line) => `<li>${renderInline(line.replace(/^\d+\.\s+/, ""))}</li>`).join("")
    return `<ol>${items}</ol>`
  }

  const headingMatch = lines.length === 1 && lines[0].match(/^(#{1,6})\s+(.*)$/)
  if (headingMatch) {
    const level = headingMatch[1].length
    return `<h${level}>${renderInline(headingMatch[2])}</h${level}>`
  }

  return `<p>${lines.map(renderInline).join("<br>")}</p>`
}

function renderMarkdown(text) {
  return text
    .split(/\n{2,}/)
    .map(renderBlock)
    .join("")
}
