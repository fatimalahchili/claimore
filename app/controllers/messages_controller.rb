class MessagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[create]
  before_action :set_chat
  before_action :authorize_chat!

  def create
    content = params.dig(:message, :content)
    if content.present?
      ChatResponseJob.perform_later(@chat.id, content)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @chat }
      end
    end
  end

  private

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end

  def authorize_chat!
    return if @chat.user.nil? && @chat.session_id == guest_chat_session_id
    return if @chat.user.present? && (@chat.user == current_user || @chat.claim&.users&.include?(current_user))

    redirect_to root_path, alert: "Not authorized."
  end
end
