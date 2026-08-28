class TenantMailer < ApplicationMailer
  def added(tenant)
    @tenant = tenant
    @property = tenant.property
    mail(to: tenant.user.email, subject: "You've been added to #{@property.address}")
  end
end
