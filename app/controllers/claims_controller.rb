class ClaimsController < ApplicationController
  before_action :set_claim, only: %i[show edit update destroy timeline]
  before_action :authorize_claim!, only: %i[show edit update destroy timeline]

  def index
    @properties = current_user.properties.order(:address)
    @property = selected_property
    @show_archived = params[:show_archived] == "1"
    @claims = claims_for_property
    @active_claims_count = @property ? @property.claims.where(status: "active").count : 0
    @archived_claims_count = @property ? @property.claims.where(status: "archived").count : 0
  end

  def show
    load_timeline
  end

  def timeline
    load_timeline
  end

  def new
    @claim = Claim.new
  end

  def create
    @claim = Claim.new(claim_params)
    if @claim.save
      redirect_to @claim, notice: "Claim was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @claim.update(claim_params)
      redirect_to @claim, notice: "Claim was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @claim.archived!
    redirect_to claims_path, notice: "Claim was successfully archived."
  end

  private

  def authorize_claim!
    return if @claim.users.include?(current_user)

    redirect_to root_path, alert: "Not authorized."
  end

  def load_timeline
    @entries = @claim.entries.order(date: :desc, created_at: :desc)
    @focused_entry = next_or_current_entry(@entries)
  end

  def next_or_current_entry(entries)
    dated_entries = entries.select(&:date?)
    upcoming_entry = dated_entries.select { |entry| entry.date >= Date.current }.min_by(&:date)
    upcoming_entry || dated_entries.max_by(&:date) || entries.first
  end

  def set_claim
    @claim = Claim.find(params[:id] || params[:claim_id])
  end

  def claim_params
    params.require(:claim).permit(:category, :status, :property_id)
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
