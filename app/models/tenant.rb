class Tenant < ApplicationRecord
  belongs_to :user
  belongs_to :property

  enum :role,
       { guest: "guest", main_tenant: "main_tenant", sub_tenant: "sub_tenant", co_tenant: "co_tenant", life_partner: "life_partner" }, default: :guest # rubocop:disable Layout/LineLength
end
