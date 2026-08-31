class EntriesController < ApplicationController
  before_action :set_entry, only: %i[show destroy update edit]
  before_action :authorize_entry!, only: %i[show destroy update edit]

  def index
    @entries = Entry.where(claim: current_user.claims).order(date: :desc, created_at: :desc)
  end

  def edit
  end

  def show
  end

  def new
    claim = params[:claim_id].present? ? current_user.claims.find(params[:claim_id]) : current_user.claims.first
    @entry = Entry.new(claim: claim)
  end

  def create
    claim = current_user.claims.find(entry_params[:claim_id])
    @entry = claim.entries.new(entry_params.except(:claim_id))

    if @entry.save
      redirect_to @entry
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @entry.update(entry_params.except(:claim_id))
      redirect_to @entry, notice: "Entry updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    claim = @entry.claim
    @entry.destroy
    redirect_to claim_path(claim), notice: "Entry deleted."
  end

  private

  def authorize_entry!
    return if @entry.claim.users.include?(current_user)

    redirect_to root_path, alert: "Not authorized."
  end

  def set_entry
    @entry = Entry.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:title, :description, :category, :status, :date, :claim_id)
  end
end
