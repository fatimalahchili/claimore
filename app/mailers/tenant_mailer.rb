class TenantMailer < ApplicationMailer
  def added(tenant)
    @tenant = tenant
    @property = Property.find(tenant.property_id)
    mail(to: tenant.user.email, subject: "You've been added to #{@property.address}")
    p "hello from mailer"
  end
end
