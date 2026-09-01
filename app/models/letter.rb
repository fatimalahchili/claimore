class Letter < ApplicationRecord
  belongs_to :claim
  has_many :entries, dependent: :nullify
  has_one_attached :pdf

  validates :title, presence: true
end
