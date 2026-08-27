class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :claim
  has_one :property, through: :claim
  has_many :messages, dependent: :destroy
end
