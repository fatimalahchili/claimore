class DashboardController < ApplicationController
  def index
    @properties = current_user.properties.distinct.order(:address)
    @active_claims_count = current_user.claims.active.distinct.count
    @next_entry = Entry.includes(claim: :property)
                       .where(claim_id: current_user.claims.select(:id))
                       .where("entries.date >= ?", Date.current)
                       .order(:date)
                       .first
  end
end
