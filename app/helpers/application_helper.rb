module ApplicationHelper
  # Lets the chat widget gain context from whichever controller/page rendered it,
  # without every controller needing to know about the widget.
  def current_context_claim
    return @claim if defined?(@claim) && @claim.present?
    return @entry.claim if defined?(@entry) && @entry.present?
    return @letter.claim if defined?(@letter) && @letter.present?

    nil
  end
end
