class Contact < ApplicationRecord
  belongs_to :property
  validates :name, :role, presence: true
end
