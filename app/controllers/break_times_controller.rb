class BreakTimesController < ApplicationController
  before_action :set_team, :set_timer

  # POST /break_times/pause
  def create
    # current_timerがnilでないことを確認
    unless @timer
      render json: { error: 'タイマーが開始されていません' }, status: :unprocessable_entity
      return
    end

    @break_time = @timer.break_times.create(break_start_time: Time.current, user: current_user)
    return unless @break_time.persisted?

    render json: { break_time: @break_time, breakTimeId: @break_time.id }, status: :ok
  end

  # POST /break_times/resume
  def update
    @break_time = @timer.break_times.last
    if @break_time.update(break_end_time: Time.current, user: current_user)
      render json: @break_time, status: :ok
    else
      render json: @break_time.errors, status: :unprocessable_entity
    end
  end

  private

  def set_team
    @team = current_user.teams.find(params[:team_id])
    return if @team.user == current_user || @team.attendees.include?(current_user)

    redirect_to root_path, alert: 'アクセス権限がありません。'
  end

  def set_timer
    @timer = @team.timers.where(user: current_user, end_time: nil).last
  end
end
