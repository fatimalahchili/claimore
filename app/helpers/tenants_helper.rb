module TenantsHelper
  def tenant_status_classes(status)
    {
      "invited" => "text-bg-warning",
      "tenant" => "text-bg-success",
      "removed" => "text-bg-secondary"
    }.fetch(status.to_s, "text-bg-light")
  end
end
