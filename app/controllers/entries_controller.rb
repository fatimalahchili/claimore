class EntriesController < ApplicationController
  before_action :set_entry, only: %i[show destroy update edit]
  before_action :authorize_entry!, only: %i[show destroy update edit]

  def index
    @entries = Entry.all
  end

  def edit
  end

  def show
  end

  def new
    @entry = Entry.new
  end

  def create
    @entry = Entry.new(entry_params)
    unless @entry.claim.users.include?(current_user)
      redirect_to root_path, alert: "Not authorized."
      return
    end

    if @entry.save
      redirect_to @entry
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @entry.update(entry_params)
      redirect_to @entry
    else
      render :edit
    end
  end

  def destroy
    @entry.destroy
    redirect_to entries_path, notice: "Entry deleted."
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
