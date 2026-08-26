class LettersController < ApplicationController
  before_action :set_letter, only: %i[show destroy]
  before_action :set_claim, only: %i[new create]

  def show
  end

  def new
    @letter = @claim.letters.new
  end

  def create
    @letter = @claim.letters.new(letter_params)
    if @letter.save
      redirect_to letter_path(@letter), notice: "Letter was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    claim = @letter.claim
    @letter.destroy
    redirect_to claim_path(claim), notice: "Letter was successfully deleted."
  end

  private

  def set_letter
    @letter = Letter.find(params[:id])
  end

  def set_claim
    @claim = Claim.find(params[:claim_id])
  end

  def letter_params
    params.require(:letter).permit(:title, :summary, :sent_on)
  end
end
