class DeleteClaimEntryTool < RubyLLM::Tool
  desc "Delete an existing entry from the current claim timeline after the user explicitly asks for it to be removed"

  param :entry_id, desc: "ID of the existing timeline entry to delete"

  def initialize(claim)
    @claim = claim
  end

  def execute(entry_id:)
    entry = @claim.entries.find(entry_id)
    entry.destroy!
    { success: true, entry_id: entry.id, message: "Timeline entry deleted" }
  rescue ActiveRecord::RecordNotFound
    { success: false, error: "Timeline entry was not found on this claim" }
  end
end
