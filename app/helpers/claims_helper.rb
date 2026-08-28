module ClaimsHelper
  def entry_status_classes(status)
    {
      "reported" => "timeline-entry--reported",
      "open" => "timeline-entry--open",
      "resolved" => "timeline-entry--resolved",
      "pending" => "timeline-entry--pending",
      "escalated" => "timeline-entry--escalated"
    }.fetch(status.to_s.downcase, "timeline-entry--default")
  end

  def claim_status_classes(status)
    status.to_s == "archived" ? "text-bg-secondary" : "text-bg-success"
  end
end
