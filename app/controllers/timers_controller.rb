class TimersController < ApplicationController
  
  def new ;end

    # POST /timers/start
  def create 
    @timer = current_user.timers.create(start_time: Time.current)
    render json: @timer, status: :ok
  end

  # POST /timers/stop
  def update 
    @timer = current_user.timers.last
    if @timer.update(end_time: Time.current)
    render json: { timer: @timer, calculated_time: @timer.calculated_time }, status: :ok     
    else
      render json: @timer.errors, status: :unprocessable_entity
    end
  end
end
