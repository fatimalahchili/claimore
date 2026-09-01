class Chat < ApplicationRecord
  acts_as_chat
  belongs_to :claim, optional: true
  belongs_to :user, optional: true
  validates :session_id, presence: true, if: -> { user.nil? }

  ASSISTANT_PERSONA = <<~INSTRUCTIONS.strip
    You are Clem', a warm and concise assistant inside Claimore, an app that helps tenants pursue deposit and disrepair claims against landlords. Give practical, specific advice, and ground your answers in the claim details below when they're provided instead of speaking generically.
  INSTRUCTIONS

  def system_instructions
    return ASSISTANT_PERSONA if claim.nil?

    "#{ASSISTANT_PERSONA}\n\n#{claim.chat_context}"
  end
end
