class ClaimsController < ApplicationController
  def index
  end

  def timeline
    @claim = Claim.find(params[:claim_id])
    @entries = @claim.entries.order(:created_at)
  end

  def show
    @claim = Claim.find(params[:id])
  end

  def new
  end

  def create
  end

  def destroy
  end

  def update
  end
end
