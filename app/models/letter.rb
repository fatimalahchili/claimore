class Letter < ApplicationRecord
  belongs_to :claim

  validates :content, presence: true
end
