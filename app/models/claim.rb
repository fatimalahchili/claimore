class Claim < ApplicationRecord
  belongs_to :property

  has_many :tenants, through: :property
  has_many :letters
  has_many :entries
  has_many :users, through: :tenants
end
