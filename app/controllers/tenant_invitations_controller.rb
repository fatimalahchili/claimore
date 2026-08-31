class TenantInvitationsController < ApplicationController
  before_action :set_property, only: %i[create show]
  before_action :authorize_main_tenant!, only: %i[create show]
  before_action :set_invitation, only: %i[show]
  before_action :set_invitation_by_token, only: %i[join accept]

  def create
    user = User.find(params[:user_id])
    @invitation = @property.tenant_invitations.new(user: user, invited_by: current_user)

    if @invitation.save
      deliver_invitation(@invitation) if params[:delivery_method] == "email"
      redirect_to property_tenant_invitation_path(@property, @invitation), notice: @notice
    else
      redirect_to new_property_tenant_path(@property), alert: @invitation.errors.full_messages.to_sentence
    end
  end

  def show
    @invite_url = join_invitation_url(@invitation.token)
    @qr_code = RQRCode::QRCode.new(@invite_url)
  end

  def join
    unless @invitation.pending?
      redirect_to root_path, alert: "This invitation is no longer valid." and return
    end

    unless @invitation.user == current_user
      redirect_to root_path, alert: "This invitation isn't for your account." and return
    end

    @property = @invitation.property
  end

  def accept
    if @invitation.user == current_user && @invitation.accept!
      redirect_to @invitation.property, notice: "You've joined #{@invitation.property.address}."
    else
      redirect_to root_path, alert: "This invitation could not be accepted."
    end
  end

  private

  def set_property
    @property = Property.find(params[:property_id])
  end

  def authorize_main_tenant!
    return if @property.tenants.exists?(user: current_user, role: "main_tenant")

    redirect_to root_path, alert: "Not authorized."
  end

  def set_invitation
    @invitation = @property.tenant_invitations.find(params[:id])
  end

  def set_invitation_by_token
    @invitation = TenantInvitation.find_by!(token: params[:token])
  end

  def deliver_invitation(invitation)
    TenantMailer.with(invitation: invitation).invited.deliver_later
    @notice = "Invitation email sent to #{invitation.user.email}."
  end
end
