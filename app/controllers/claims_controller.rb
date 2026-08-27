class ClaimsController < ApplicationController
  before_action :set_claim, only: %i[show edit update destroy timeline]

  def index
    @claims = Claim.all
  end

  def show
    @entries = @claim.entries.order(date: :desc, created_at: :desc)
  end

  def timeline
    @entries = @claim.entries.order(date: :desc, created_at: :desc)
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
    @claim.destroy
    redirect_to claims_path, notice: "Claim was successfully deleted."
  end

  private

  def set_claim
    @claim = Claim.find(params[:id] || params[:claim_id])
  end

  def claim_params
    params.require(:claim).permit(:category, :status, :property_id)
  end
end

