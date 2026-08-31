class Chat < ApplicationRecord
  acts_as_chat
  belongs_to :claim, optional: true
  belongs_to :user
end
