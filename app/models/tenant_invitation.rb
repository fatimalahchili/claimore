class TenantInvitation < ApplicationRecord
  belongs_to :property
  belongs_to :user
  belongs_to :invited_by, class_name: "User"

  has_secure_token :token

  validates :user_id, uniqueness: { scope: :property_id, message: "has already been invited to this property" }
  validate :user_not_already_a_tenant

  def pending?
    accepted_at.nil?
  end

  def accept!
    return false unless pending?

    transaction do
      update!(accepted_at: Time.current)
      property.tenants.create!(user: user, role: role)
    end
  end

  private

  def user_not_already_a_tenant
    return unless property && user
    return unless property.tenants.exists?(user: user)

    errors.add(:user_id, "is already a tenant of this property")
  end
end
