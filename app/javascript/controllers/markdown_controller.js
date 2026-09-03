import { Controller } from "@hotwired/stimulus"

// Renders the lightweight Markdown Clem is instructed to write (bold, headings,
// lists, inline code) as real HTML. Re-runs on every mutation so it keeps up
// as the response streams in, then settles once streaming stops.
//
// The server marks one render as "final" (via the `final` value below) once
// the whole reply has been generated and persisted. A streamed reply's chunks
// are delivered over a channel that doesn't guarantee exactly-once delivery,
// and an upstream retry on a transient API error can also re-broadcast an
// overlapping tail — either way a stray chunk can arrive after that final
// render. Once finalized, this controller is frozen: any further mutation is
// reverted rather than rendered, since nothing legitimate should change the
// content after that point.
export default class extends Controller {
  static values = { final: { type: Boolean, default: false } }

  connect() {
    this.observer = new MutationObserver(() => this.handleMutation())
    this.lastRaw = this.element.textContent
    this.render()
    this.frozen = this.finalValue
    // Keep observing even when frozen: that's how a stray post-finalization
    // mutation gets caught (and reverted) in the first place.
    this.observer.observe(this.element, { childList: true, characterData: true, subtree: true })
  }

  disconnect() {
    this.observer?.disconnect()
  }

  handleMutation() {
    if (this.frozen) {
      // A stray post-finalization mutation: revert it rather than render it.
      this.element.innerHTML = this.lastRenderedHtml
      this.observer.takeRecords()
      return
    }

    const raw = this.element.textContent
    if (raw === this.lastRaw) return

    this.lastRaw = raw
    this.render()
  }

  render() {
    this.lastRenderedHtml = renderMarkdown(this.lastRaw)
    this.element.innerHTML = this.lastRenderedHtml
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
    // Content allows lone `*` chars (not part of a `**` pair) so a bold span
    // can wrap a nested `*italic*` run, e.g. "**label (*term*)**" — the
    // pattern Clem is instructed to use for labeled list items.
    .replace(/\*\*((?:\*(?!\*)|[^*])+?)\*\*/g, "<strong>$1</strong>")
    .replace(/(?<!\*)\*([^*]+)\*(?!\*)/g, "<em>$1</em>")
    .replace(/(?<!_)_([^_]+)_(?!_)/g, "<em>$1</em>")
}

// Line-based rather than blank-line-block-based: LLM output doesn't always
// separate a heading/intro line from the list beneath it with a blank line,
// so list/heading detection runs per line instead of requiring a whole
// paragraph block to uniformly match.
function renderMarkdown(text) {
  let html = ""
  let paragraphLines = []
  let list = null

  const flushParagraph = () => {
    if (paragraphLines.length > 0) {
      html += `<p>${paragraphLines.map(renderInline).join("<br>")}</p>`
      paragraphLines = []
    }
  }

  const flushList = () => {
    if (list) {
      html += `<${list.type}>${list.items.map((item) => `<li>${renderInline(item)}</li>`).join("")}</${list.type}>`
      list = null
    }
  }

  for (const rawLine of text.split("\n")) {
    const line = rawLine.trim()

    if (line.length === 0) {
      flushParagraph()
      flushList()
      continue
    }

    const headingMatch = line.match(/^(#{1,6})\s+(.*)$/)
    if (headingMatch) {
      flushParagraph()
      flushList()
      const level = headingMatch[1].length
      html += `<h${level}>${renderInline(headingMatch[2])}</h${level}>`
      continue
    }

    const bulletMatch = line.match(/^[-*]\s+(.*)$/)
    if (bulletMatch) {
      flushParagraph()
      if (list?.type !== "ul") {
        flushList()
        list = { type: "ul", items: [] }
      }
      list.items.push(bulletMatch[1])
      continue
    }

    const numberedMatch = line.match(/^\d+\.\s+(.*)$/)
    if (numberedMatch) {
      flushParagraph()
      if (list?.type !== "ol") {
        flushList()
        list = { type: "ol", items: [] }
      }
      list.items.push(numberedMatch[1])
      continue
    }

    flushList()
    paragraphLines.push(line)
  }

  flushParagraph()
  flushList()
  return html
}
