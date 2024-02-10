class BreakTimesController < ApplicationController
  before_action :set_team, :set_timer
  
  # POST /break_times/pause
  def create 
    # current_timerがnilでないことを確認
    unless @timer 
      render json: { error: "タイマーが開始されていません" }, status: :unprocessable_entity
      return
    end

    @break_time = @timer.break_times.create(break_start_time: Time.current, user: @team.user)
    if @break_time.persisted?
      render json: { break_time: @break_time, breakTimeId: @break_time.id }, status: :ok
    end
  end
  
    # POST /break_times/resume
  def update
    @break_time = @timer.break_times.last
    if @break_time.update(break_end_time: Time.current, user: @team.user)
      render json: @break_time, status: :ok
    else
      render json: @break_time.errors, status: :unprocessable_entity
    end
  end

  private
      
  def set_team
    @team = current_user.teams.find(params[:team_id])
  end

  # 現在のタイマーを取得または適切なタイマーを特定する
  def set_timer
    @timer = @team.timers.last
  end
end
