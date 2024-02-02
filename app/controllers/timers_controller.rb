class TimersController < ApplicationController
  before_action :set_team
  
  def new
    @timer = Timer.new
  end

    # POST /timers/start
  def create
    @timer = @team.timers.create(user: current_user, start_time: Time.current)
    render json: @timer, status: :ok
  end

  # POST /timers/stop
  def update 
    @timer = @team.timers.last
    if @timer.update(user: current_user, end_time: Time.current)
    render json: { timer: @timer, calculated_time: @timer.calculated_time }, status: :ok     
    else
      render json: @timer.errors, status: :unprocessable_entity
    end
  end

  private
  
  def set_team
    @team = current_user.teams.find(params[:team_id])
  end
end
