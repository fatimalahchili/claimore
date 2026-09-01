class DraftLetterTool < RubyLLM::Tool
  desc "Fill in a letter template with field values and draft a new letter for the current claim, without saving it, so the user can review and edit it before sending"

  param :template_id, desc: "ID of the template to use, from get_templates"
  param :fields, desc: 'JSON object mapping every one of the template\'s required_fields variable names to its filled-in value, e.g. {"recipient_name": "...", "defect_description": "..."}'
  param :sent_on, desc: "Planned send date in YYYY-MM-DD format", required: false

  def initialize(claim)
    @claim = claim
  end

  def execute(template_id:, fields:, sent_on: nil)
    template = Template.find(template_id)
    letter = @claim.letters.new(title: template.name, summary: fill_in(template.content, fields), sent_on: parse_date(sent_on))

    return { success: false, error: letter.errors.full_messages.to_sentence }.to_json unless letter.valid?

    { success: true, title: letter.title, summary: letter.summary, sent_on: letter.sent_on&.iso8601, edit_url: edit_url(letter) }.to_json
  rescue ActiveRecord::RecordNotFound
    { success: false, error: "Template not found" }.to_json
  rescue JSON::ParserError
    { success: false, error: "fields must be a valid JSON object" }.to_json
  rescue Date::Error
    { success: false, error: "sent_on must use YYYY-MM-DD format" }.to_json
  end

  private

  def fill_in(content, fields)
    values = JSON.parse(fields).merge("date" => I18n.l(Date.current, format: :long))
    content.gsub(/\{\{(\w+)\}\}/) { values[Regexp.last_match(1)] || Regexp.last_match(0) }
  end

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
