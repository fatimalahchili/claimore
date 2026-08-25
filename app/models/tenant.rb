class Tenant < ApplicationRecord
  belongs_to :user
  belongs_to :claim
  belongs_to :property
end
