class ChatRoom < ApplicationRecord
  has_many :direct_messages, dependent: :destroy

  belongs_to :user1, class_name: "User"
  belongs_to :user2, class_name: "User"

  def other_user(current_user)
    user1 == current_user ? user2 : user1
  end
  
  def self.find_or_create_by_users(user1,user2)
    user1, user2 = [user1, user2].sort_by(&:id)
    chat_room = ChatRoom.find_by(user1: user1, user2: user2)
    chat_room ||= ChatRoom.create(user1: user1, user2: user2)
    chat_room
  end

end
