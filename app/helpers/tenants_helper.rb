module TenantsHelper
  def tenant_status_classes(status)
    {
      "invited" => "text-bg-warning",
      "added" => "text-bg-success",
      "removed" => "text-bg-secondary"
    }.fetch(status.to_s, "text-bg-light")
  end
end
