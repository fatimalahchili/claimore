class TenantMailerPreview < ActionMailer::Preview
  def added
    TenantMailer.added(tenant: Tenant.last).added
  end
end
