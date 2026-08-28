class DashboardController < ApplicationController
  def index
    @active_claims_count = current_user.claims.active.count
    @next_entry = Entry.includes(:claim)
                       .where(claim: current_user.claims)
                       .where("entries.date >= ?", Date.current)
                       .order(:date)
                       .first
  end
end
