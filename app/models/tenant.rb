class Tenant < ApplicationRecord
  belongs_to :user
  belongs_to :property
  validates :user_id, uniqueness: { scope: :property_id, message: "is already a tenant of this property" }

  def main_tenant?
    role == "main_tenant"
  end
end
