class RoomsController < ApplicationController
  def show
    @room = Room.find(params[:id])
    @messages = @room.messages 
  end
end
