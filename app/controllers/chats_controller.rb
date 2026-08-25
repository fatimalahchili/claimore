class ChatsController < ApplicationController
  before_action :set_chat, only: [ :destroy ]
  before_action :set_claim, only: [ :create, :new ]

  def new
    @chat = Chat.new
    @chat.claim = @claim
  end

  def create
    @chat = current_user.chats.new(chat_params)
    @chat.claim = @claim
    if @chat.save
      redirect_to @chat.claim
    else
      render "chats/new"
    end
  end

  def destroy
    @chat.destroy
    redirect_to @chat.claim
  end

  private

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
