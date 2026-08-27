class Chat < ApplicationRecord
  acts_as_chat
  belongs_to :claim
  belongs_to :user
end
