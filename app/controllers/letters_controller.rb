class LettersController < ApplicationController
  before_action :set_letter, only: %i[show destroy]
  before_action :set_claim, only: %i[new create]
  before_action :authorize_claim!, only: %i[new create]
  before_action :authorize_letter!, only: %i[show destroy]

  def new
    @letter = Letter.new
    @letter.claim = @claim
  end

  def create
    @letter = Letter.new(letter_params)
    @letter.claim = @claim
    if @letter.save
      redirect_to @letter
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
    claim = @letter.claim
    @letter.destroy
    redirect_to claim, notice: "Letter deleted."
  end

  private

  def authorize_claim!
    return if @claim.users.include?(current_user)

    redirect_to root_path, alert: "Not authorized."
  end

  def authorize_letter!
    return if @letter.claim.users.include?(current_user)

    redirect_to root_path, alert: "Not authorized."
  end

  def set_claim
    @claim = Claim.find(params[:claim_id])
  end

  def set_letter
    @letter = Letter.find(params[:id])
  end

  def letter_params
    params.require(:letter).permit(:content)
  end
end
