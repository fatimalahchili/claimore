class Letter < ApplicationRecord
  belongs_to :claim
  has_many :entries, dependent: :nullify

  validates :title, presence: true
end
