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
    
    Use get_templates when the user wants help writing a letter, to see the available templates and their required_fields.
    Once a template is chosen, gather a value for every one of its required_fields from claim, property, and user-supplied details, asking a concise follow-up for anything missing; never guess a value.
    All templates are in German, so every field value must be in formal German too, no matter what language the user wrote it in: translate any English (or other language) input into formal German yourself before including it in the fields JSON. Do not leave any field in its original language.
    As soon as every required field is known, you must call draft_letter with the template_id and those fields as a JSON object before replying; never type or paste the filled-in letter text yourself, even as a preview, since only draft_letter actually creates a letter the user can review, edit, and send.
    After draft_letter succeeds, tell the user their letter is ready and to use the button shown above to review, edit, and send it. Never retype or repeat the edit_url yourself.
    Use update_claim_entry when the user explicitly asks to change an existing timeline event. Use get_claim_context first when the entry ID is not already known, and never create a new entry when the user asked to edit one.
    Keep responses concise and tell the user when an entry was created or updated.

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
