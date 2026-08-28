class ClaimsController < ApplicationController
  def index
    @properties = current_user.properties.order(:address)
    @property = selected_property
    @show_archived = params[:show_archived] == "1"
    @claims = claims_for_property
    @active_claims_count = @property ? @property.claims.where(status: "active").count : 0
    @archived_claims_count = @property ? @property.claims.where(status: "archived").count : 0
  end

  def timeline
    @claim = Claim.find(params[:claim_id])
    @entries = @claim.entries.order(:created_at)
  end

  def show
  end

  def new
  end

  def create
  end

  def destroy
  end

  def update
  end

  private

  def selected_property
    return @properties.first if params[:property_id].blank?

    @properties.find(params[:property_id])
  end

  def claims_for_property
    return Claim.none unless @property

    statuses = @show_archived ? %w[active archived] : ["active"]
    @property.claims.where(status: statuses).order(created_at: :desc)
  end
end
