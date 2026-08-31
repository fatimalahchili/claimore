class CreateClaimEntryTool < RubyLLM::Tool
  desc "Add an event to the current claim timeline after the user explicitly asks for it"

  param :title, desc: "Short factual title for the timeline event"
  param :description, desc: "Factual description based only on information supplied by the user"
  param :date, desc: "Event date in YYYY-MM-DD format"
  param :category, desc: "Optional event category", required: false
  param :status, desc: "Optional event status", required: false

  def initialize(claim)
    @claim = claim
  end

  def execute(title:, description:, date:, category: nil, status: nil)
    entry = create_entry(title:, description:, date:, category:, status:)

    { success: true, entry_id: entry.id, message: "Timeline entry created" }
  rescue Date::Error
    { success: false, error: "Date must use YYYY-MM-DD format" }
  rescue ActiveRecord::RecordInvalid => e
    { success: false, error: e.record.errors.full_messages.to_sentence }
  end

  private

  def create_entry(title:, description:, date:, category:, status:)
    @claim.entries.create!(title:, description:, date: Date.iso8601(date), category:, status:)
  end
end
