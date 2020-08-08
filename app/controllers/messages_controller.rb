class MessagesController < ApplicationController
  before_action :authenticate_user!, :only => [:create]

  def create
    if Entry.where(:user_id => current_user.id, :room_id => params[:message][:room_id]).present?
      @message = Message.create(params.require(:message).permit(:user_id, :content, :room_id).merge(:user_id => current_user.id))
      room = Room.find(params[:message][:room_id])
      entries = room.entries
      entry = entries.where.not(:user => current_user).first
      user = entry.user
      user.create_notification_message!(current_user, @message.id, user.id)
      redirect_back(fallback_location: root_path)
    end
  end
end
