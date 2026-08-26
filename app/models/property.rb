class Property < ApplicationRecord
  has_many :claims
  has_many :tenants
end
