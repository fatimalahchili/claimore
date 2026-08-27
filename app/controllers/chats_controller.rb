class ChatsController < ApplicationController
  before_action :set_chat, only: %i[destroy show]
  before_action :set_claim, only: %i[create new]
  before_action :authorize_claim!, only: %i[new create]
  before_action :authorize_chat!, only: %i[destroy show]

  def new
    @chat = Chat.new
    @chat.claim = @claim
  end

  def show
    @messages = @chat.messages
  end

  def create
    @chat = current_user.chats.new(chat_params)
    @chat.claim = @claim
    if @chat.save
      redirect_to @claim
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @chat.destroy
    redirect_to @chat.claim, notice: "Chat deleted."
  end

  private

  def authorize_claim!
    return if @claim.users.include?(current_user)

    redirect_to root_path, alert: "Not authorized."
  end

  def authorize_chat!
    return if @chat.claim.users.include?(current_user)

    redirect_to root_path, alert: "Not authorized."
  end

  def set_claim
    @claim = Claim.find(params[:claim_id])
  end

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def chat_params
    params.require(:chat).permit(:title)
  end
end
