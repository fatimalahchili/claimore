class Property < ApplicationRecord
  has_many :tenants, dependent: :destroy
  has_many :users, through: :tenants
  has_many :claims, dependent: :destroy
  has_many :contacts, dependent: :destroy
end

