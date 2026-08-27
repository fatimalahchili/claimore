class ChatsController < ApplicationController
  before_action :set_chat, only: %i[show destroy]
  before_action :set_claim, only: %i[new create]
  before_action :authorize_claim!, only: %i[new create]
  before_action :authorize_chat!, only: %i[show destroy]

  def index
    @chats = current_user.chats.order(created_at: :desc)
  end

  def new
    @chat = Chat.new
  end

  def create
    prompt = params.dig(:chat, :prompt)
    if prompt.present?
      @chat = current_user.chats.create!(claim: @claim)
      ChatResponseJob.perform_later(@chat.id, prompt)

      redirect_to @chat, notice: "Chat was successfully created."
    else
      @chat = @claim.chats.new
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @message = @chat.messages.build
  end

  def destroy
    @chat.destroy!
    redirect_to chats_path, notice: "Chat was successfully destroyed.", status: :see_other
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def set_claim
    @claim = Claim.find(params[:claim_id] || params.dig(:chat, :claim_id))
  end

  def authorize_claim!
    return if @claim.users.include?(current_user)

    redirect_to root_path, alert: "Not authorized."
  end

  def authorize_chat!
    return if @chat.claim.users.include?(current_user)

    redirect_to root_path, alert: "Not authorized."
  end
end
