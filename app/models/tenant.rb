class Tenant < ApplicationRecord
  belongs_to :user
  belongs_to :property (as it is a foreign key)
end
