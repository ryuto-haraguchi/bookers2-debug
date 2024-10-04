class ChatRoomsController < ApplicationController
  def index
    @chat_rooms = ChatRoom.where("user1_id = ? OR user2_id = ?", current_user.id, current_user.id)
  end
  
  def create
    @chat_room = ChatRoom.find_or_create_by_users(current_user, User.find(params[:user_id]))
    redirect_to @chat_room
  end

  def show
    @chat_room = ChatRoom.find(params[:id])
    @direct_messages = @chat_room.direct_messages
  end
  
  private
  
  def chat_room_params
    params.require(:char_room).permit(:user1_id, :user2_id)
  end
  
end
