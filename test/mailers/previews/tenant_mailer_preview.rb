class TenantMailerPreview < ActionMailer::Preview
  def added
    TenantMailer.with(tenant: Tenant.last).added
  end

  def invited
    TenantMailer.with(invitation: TenantInvitation.last).invited
  end
end
