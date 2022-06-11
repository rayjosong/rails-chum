class ChatroomsController < ApplicationController
  def index
    @chatrooms = policy_scope(Chatroom).where(id: current_user.chatroom_ids)
  end

  def show
    @chatroom = authorize Chatroom.find(params[:id])
    @message = Message.new
  end
end
