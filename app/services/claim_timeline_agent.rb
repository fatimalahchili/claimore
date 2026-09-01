class ClaimTimelineAgent
  GENERAL_INSTRUCTIONS = <<~PROMPT.freeze
    You assist a tenant with housing matters.
    Never invent facts, dates, actions, or legal conclusions.
    Keep responses concise and clearly distinguish general information from claim-specific facts.
  PROMPT

  CLAIM_INSTRUCTIONS = <<~PROMPT.freeze
    You assist a tenant with the current housing claim.
    Use get_claim_context whenever claim or timeline facts are needed.
    Never invent claim details, dates, actions, or legal conclusions.
    Use create_claim_entry only when the user explicitly asks to add or record a timeline event.
    Before creating an entry, ensure its title, description, and date are known; ask a concise follow-up if required information is missing.
    Use get_templates when the user wants help writing a letter, to see the available templates and their required fields.
    Once a template is chosen and its placeholders are filled in from claim, property, and user-supplied details, use draft_letter to prepare it; this does not save the letter.
    After draft_letter succeeds, tell the user their letter is ready and share the edit_url so they can review, edit, and send it.
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
    fast_chat = @chat.with_thinking(effort: :minimal).with_params(max_completion_tokens: 400)
    return fast_chat.with_runtime_instructions(GENERAL_INSTRUCTIONS) unless @chat.claim

    fast_chat.with_runtime_instructions(CLAIM_INSTRUCTIONS).with_tools(*claim_tools)
  end

  def claim_tools
    [
      GetClaimContextTool.new(@chat.claim),
      CreateClaimEntryTool.new(@chat.claim),
      GetTemplatesTool.new,
      DraftLetterTool.new(@chat.claim)
    ]
  end
end
