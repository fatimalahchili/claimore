class Claim < ApplicationRecord
  belongs_to :property

  has_many :tenants, through: :property
  has_many :chats, dependent: :destroy
  has_many :letters, dependent: :destroy
  has_many :entries

  has_many :messages, through: :chats
  # has_one :user, through: :tenants possible but prone to problems according to Claude
  has_many :users, through: :tenants
end
