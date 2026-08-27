class EntriesController < ApplicationController
  before_action :set_entry, only: %i[show destroy update]

  def index
    @entries = Entry.all
  end

  def show
  end

  def new
    @entry = Entry.new
  end

  def create
    @entry = Entry.new(entry_params)
    if @entry.save
      redirect_to @entry
    else
      render :new, status: :uprocessable_entity
    end
  end

  def update
    @entry.update
  end

  def destroy
    @entry.destroy
    redirect_to :new, notice: "Entry deleted."
  end

  private

  def set_entry
    @entry = Entry.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:title, :description, :category)
  end
end
