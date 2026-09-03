class ChatResponseJob < ApplicationJob
  # Clem is instructed to reply with exactly one canned sentence for two cases
  # (a message in a third language, or an off-topic message), picking English
  # or German to match. In practice the model doesn't reliably comply — it
  # tacks on an answer, adds a parenthetical translation, or just picks the
  # wrong language for an otherwise clean single-sentence reply. Rather than
  # trust generation for any of that, detect that a refusal was intended and
  # replace the whole message with a deterministic canonical phrase, choosing
  # the language ourselves from the user's own message.
  LANGUAGE_REFUSAL_OPENER = /\A\s*(?:sorry|es tut mir leid)\b(?=.{0,150}\benglish\b)(?=.{0,150}\bgerman\b)(?=.{0,150}\bonly\b)/i
  SCOPE_REFUSAL_OPENER = /\A\s*(?:sorry,?\s+i\s+cannot\s+help\s+you\s+with\s+that\.?|es\s+tut\s+mir\s+leid,?\s+dabei\s+kann\s+ich\s+ihnen\s+nicht\s+helfen\.?)/i

  LANGUAGE_REFUSAL_TEXT = "Sorry, I only speak German & English."
  SCOPE_REFUSAL_TEXT = {
    "en" => "Sorry, I cannot help you with that.",
    "de" => "Es tut mir leid, dabei kann ich Ihnen nicht helfen."
  }.freeze

  GERMAN_STOPWORDS = %w[und ich nicht mit ist sie der die das ein eine wie was wann wo warum sollte muss möchte bitte danke hallo für].freeze

  def perform(chat_id, content)
    chat = Chat.find(chat_id)

    ClaimTimelineAgent.new(chat).ask(content) do |chunk|
      if chunk.content && !chunk.content.empty?
        message = chat.messages.last
        message.broadcast_append_chunk(chunk.content)
      end
    end

    enforce_canonical_refusal(chat, content)
  end

  private

  # ruby_llm's own completion save (Message#after_update_commit, see
  # message.rb) already broadcasts the final, settled reply — we don't need
  # (and previously shouldn't have added) a second broadcast of our own here,
  # since two independent broadcast sources can arrive out of order and stomp
  # each other. A real `update!` here (not update_column) reuses that same
  # single broadcast path for the canonical-refusal override, so there's only
  # ever one mechanism producing the final render.
  def enforce_canonical_refusal(chat, user_content)
    message = chat.messages.where(role: "assistant").order(:created_at).last
    return unless message

    reply = message.content.to_s
    canonical = canonical_refusal_for(reply, user_content)
    return if canonical.nil? || reply == canonical

    message.update!(content: canonical)
  end

  def canonical_refusal_for(reply, user_content)
    return LANGUAGE_REFUSAL_TEXT if reply.match?(LANGUAGE_REFUSAL_OPENER)
    return SCOPE_REFUSAL_TEXT.fetch(german_input?(user_content) ? "de" : "en") if reply.match?(SCOPE_REFUSAL_OPENER)

    nil
  end

  def german_input?(text)
    text = text.to_s.downcase
    return true if text.match?(/[äöüß]/)

    text.scan(/\p{L}+/).any? { |word| GERMAN_STOPWORDS.include?(word) }
  end
end
