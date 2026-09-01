class MessagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[create]
  before_action :set_chat
  before_action :authorize_chat!

  RELEVANT_LAW_TEXTS_COUNT = 5

  def create
    content = params.dig(:message, :content)
    return unless content.present?

    @chat.with_instructions(system_prompt(content), replace: true)

    ChatResponseJob.perform_later(@chat.id, content)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @chat }
    end
  end

  private

  def system_prompt(content)
    vector = RubyLLM.embed(translate_to_german(content)).vectors
    relevant_law_texts = LawText.nearest_neighbors(:embedding, vector, distance: "cosine")
                                .limit(RELEVANT_LAW_TEXTS_COUNT)
    laws = relevant_law_texts.map do |law_text|
      "#{law_text.paragraph_title}\n#{law_text.content}"
    end.join("\n\n")

    <<~PROMPT
      You are a legal assistant specialized in German tenancy law (Mietrecht) under the Bürgerliches Gesetzbuch (BGB).
      Base your answer primarily on the following BGB provisions, retrieved as the most relevant to the user's message, and cite the § number whenever you rely on one of them.
      If none of them apply to the question, say so instead of inventing a legal basis and recommend the User to reach out to a lawyer.

      #{laws}
    PROMPT
  end

  def translate_to_german(content)
    RubyLLM.chat
           .with_instructions("Translate the user's message to German. Reply with only the translation, nothing else.")
           .ask(content)
           .content
  end

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end

  def authorize_chat!
    return if @chat.user.nil? && @chat.session_id == guest_chat_session_id
    return if @chat.user.present? && (@chat.user == current_user || @chat.claim&.users&.include?(current_user))

    redirect_to root_path, alert: "Not authorized."
  end
end
