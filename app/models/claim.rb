class Claim < ApplicationRecord
  belongs_to :property

  scope :active, -> { where.not(status: "resolved") }

  has_many :tenants, through: :property
  has_many :letters
  has_many :entries
  has_many :users, through: :tenants
  has_many :chats, dependent: :destroy
end
