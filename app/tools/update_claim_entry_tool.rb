class UpdateClaimEntryTool < RubyLLM::Tool
  desc "Update an existing event on the current claim timeline after the user explicitly asks for a change"

  param :entry_id, desc: "ID of the existing timeline entry to update"
  param :title, desc: "Replacement title", required: false
  param :description, desc: "Replacement factual description", required: false
  param :date, desc: "Replacement event date in YYYY-MM-DD format", required: false
  param :category, desc: "Replacement event category", required: false
  param :status, desc: "Replacement event status", required: false

  def initialize(claim)
    @claim = claim
  end

  def execute(entry_id:, title: nil, description: nil, date: nil, category: nil, status: nil)
    entry = @claim.entries.find(entry_id)
    attributes = { title:, description:, category:, status: }.compact
    attributes[:date] = Date.iso8601(date) if date.present?

    return { success: false, error: "Provide at least one field to update" } if attributes.empty?

    entry.update!(attributes)
    { success: true, entry_id: entry.id, message: "Timeline entry updated" }
  rescue ActiveRecord::RecordNotFound
    { success: false, error: "Timeline entry was not found on this claim" }
  rescue Date::Error
    { success: false, error: "Date must use YYYY-MM-DD format" }
  rescue ActiveRecord::RecordInvalid => e
    { success: false, error: e.record.errors.full_messages.to_sentence }
  end
end
