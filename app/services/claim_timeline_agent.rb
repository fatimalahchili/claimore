class ClaimTimelineAgent
  INSTRUCTIONS = <<~PROMPT.freeze
    You assist a tenant with the current housing claim.
    Use get_claim_context whenever claim or timeline facts are needed.
    Never invent claim details, dates, actions, or legal conclusions.
    Use create_claim_entry only when the user explicitly asks to add or record a timeline event.
    Before creating an entry, ensure its title, description, and date are known; ask a concise follow-up if required information is missing.
    Keep responses concise and tell the user when an entry was created.
  PROMPT

  def initialize(chat)
    @chat = chat
  end

  def ask(content, &)
    configured_chat.ask(content, &)
  end

  private

  def configured_chat
    @chat
      .with_runtime_instructions(INSTRUCTIONS)
      .with_tools(
        GetClaimContextTool.new(@chat.claim),
        CreateClaimEntryTool.new(@chat.claim)
      )
  end
end
