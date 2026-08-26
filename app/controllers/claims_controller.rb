class ClaimsController < ApplicationController
  def index
  end

  def timeline
    @claim = Claim.find(params[:claim_id])
    @entries = @claim.entries
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
end
