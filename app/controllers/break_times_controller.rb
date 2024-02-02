class BreakTimesController < ApplicationController
  before_action :set_team
  
  # POST /break_times/pause
  def create 
    # 現在のタイマーを取得または適切なタイマーを特定する
    current_timer = @team.timers.last

    # current_timerがnilでないことを確認
    unless current_timer
      render json: { error: "タイマーが開始されていません" }, status: :unprocessable_entity
      return
    end

    @break_time = current_timer.break_times.create(break_start_time: Time.current, user: current_user)
    render json: @break_time, status: :ok
  end
  
    # POST /break_times/resume
  def update 
    @break_time = @team.break_times.last
    if @break_time.update(break_end_time: Time.current)
      render json: @break_time, status: :ok
    else
      render json: @break_time.errors, status: :unprocessable_entity
    end
  end

  private
      
  def set_team
    @team = current_user.teams.find(params[:team_id])
  end
end
