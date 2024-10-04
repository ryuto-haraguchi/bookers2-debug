class DirectMessage < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  validates :content, presence: true, length: { maximum: 140 }
end
