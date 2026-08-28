class Claim < ApplicationRecord
  belongs_to :property

  has_many :tenants, through: :property
  has_many :letters
  has_many :entries
  has_many :users, through: :tenants
  has_many :chats, dependent: :destroy

  enum :role,
       { guest: "guest",
         main_tenant: "main_tenant",
         sub_tenant: "sub_tenant",
         co_tenant: "co_tenant",
         life_partner: "life_partner" },
       default: :guest
end
