class DraftLetterTool < RubyLLM::Tool
  desc "Draft a new letter for the current claim from a template, without saving it, so the user can review and edit it before sending"

  param :title, desc: "Title for the letter, e.g. the template name or a short subject line"
  param :content, desc: "Full letter text with all template placeholders filled in using claim, property, and user-supplied details"
  param :sent_on, desc: "Planned send date in YYYY-MM-DD format", required: false

  def initialize(claim)
    @claim = claim
  end

  def execute(title:, content:, sent_on: nil)
    letter = @claim.letters.new(title: title, summary: content, sent_on: parse_date(sent_on))

    return { success: false, error: letter.errors.full_messages.to_sentence }.to_json unless letter.valid?

    { success: true, title: letter.title, summary: letter.summary, sent_on: letter.sent_on&.iso8601, edit_url: edit_url(letter) }.to_json
  rescue Date::Error
    { success: false, error: "sent_on must use YYYY-MM-DD format" }.to_json
  end

  private

  def parse_date(value)
    Date.iso8601(value) if value.present?
  end

  def edit_url(letter)
    Rails.application.routes.url_helpers.new_claim_letter_path(
      @claim,
      letter: { title: letter.title, summary: letter.summary, sent_on: letter.sent_on }
    )
  end
end
