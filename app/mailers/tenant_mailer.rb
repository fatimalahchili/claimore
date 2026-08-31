class TenantMailer < ApplicationMailer
  def added
    @tenant = params[:tenant]
    @property = Property.find(@tenant.property_id)
    mail(to: @tenant.user.email, subject: "You've been added to #{@property.address}")
  end
end
