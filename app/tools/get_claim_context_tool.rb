class GetClaimContextTool < RubyLLM::Tool
  desc "Get the current claim and its timeline entries"

  def initialize(claim)
    @claim = claim
  end

  def execute
    {
      claim: claim_context,
      entries: @claim.entries.order(date: :asc, created_at: :asc).map { |entry| entry_context(entry) }
    }
  end

  private

  def claim_context
    {
      id: @claim.id,
      category: @claim.category,
      status: @claim.status,
      property_address: @claim.property.address
    }
  end

  def entry_context(entry)
    entry.slice(:id, :title, :description, :category, :status).symbolize_keys.merge(date: entry.date&.iso8601)
  end
end
