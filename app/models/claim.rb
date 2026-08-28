class Claim < ApplicationRecord
  belongs_to :property

  has_many :tenants, through: :property
  has_many :letters
  has_many :entries
  has_many :users, through: :tenants
  has_many :chats, dependent: :destroy

  enum :role, { archived: "archived", active: "active" }, default: :guest
end
