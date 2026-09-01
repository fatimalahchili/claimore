class TenantMailer < ApplicationMailer
  def added
    @tenant = params[:tenant]
    @property = Property.find(@tenant.property_id)
    mail(to: @tenant.user.email, subject: "You've been added to #{@property.address}")
  end

  def invited
    @invitation = params[:invitation]
    @property = @invitation.property
    @invite_url = join_invitation_url(@invitation.token)
    mail(to: @invitation.user.email, subject: "You've been invited to join #{@property.address}")
  end
end
