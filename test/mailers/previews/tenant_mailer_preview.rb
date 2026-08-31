class TenantMailerPreview < ActionMailer::Preview
  def added
    TenantMailer.with(tenant: Tenant.last).added
  end
end
