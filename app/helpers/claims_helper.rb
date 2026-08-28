module ClaimsHelper
  def entry_status_classes(status)
    {
      "resolved" => "timeline-entry--resolved",
      "completed" => "timeline-entry--resolved",
      "pending" => "timeline-entry--pending",
      "urgent" => "timeline-entry--urgent"
    }.fetch(status.to_s.downcase, "timeline-entry--default")
  end
end
