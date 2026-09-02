class Tenant < ApplicationRecord
  belongs_to :user
  belongs_to :property
  validates :user_id, uniqueness: { scope: :property_id, message: "is already a tenant of this property" }

  enum :role,
       { guest: "guest",
         main_tenant: "main_tenant",
         sub_tenant: "sub_tenant",
         co_tenant: "co_tenant",
         life_partner: "life_partner" }, default: :guest

  enum :status,
       { invited: "invited",
         added: "added",
         removed: "removed" }, default: :invited
end
