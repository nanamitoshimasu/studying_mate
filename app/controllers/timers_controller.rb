class TimersController < ApplicationController
  before_action :set_team

  def new
    @timer = Timer.new
  end

  # POST /timers/start
  def create
    @timer = @team.timers.create(user: current_user, start_time: Time.current)
    if @timer.persisted?
      render json: { timer: @timer, timerId: @timer.id }, status: :ok
    else
      render json: { errors: @timer.errors.full_messages }, status: :unprocessable_entity
    end
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

  def edit_all_timestamps
    @timer = Timer.find(params[:id])
    @break_time = @timer.break_time.find(params[:id])
  end

  def change_all_timestamps
    @timer = Timer.find(params[:id])
    @break_time = @timer.break_time.find(params[:id])

    # Timerの時刻を更新
    start_time = Time.zone.local(*params[:timer].values_at('start_time(1i)', 'start_time(2i)', 'start_time(3i)', 'start_time(4i)', 'start_time(5i)'))
    end_time = Time.zone.local(*params[:timer].values_at('end_time(1i)', 'end_time(2i)', 'end_time(3i)', 'end_time(4i)', 'end_time(5i)'))
    @timer.start_time = start_time
    @timer.end_time = end_time

    # break_timeの時刻を更新
    break_start_time = Time.zone.local(*params[:break_time].values_at('break_start_time(1i)', 'break_start_time(2i)', 'break_start_time(3i)', 'break_start_time(4i)', 'start_time(5i)'))
    break_end_time = Time.zone.local(*params[:break_time].values_at('break_end_time(1i)', 'break_end_time(2i)', 'break_end_time(3i)', 'break_end_time(4i)', 'break_end_time(5i)'))
    @break_time.break_start_time = break_start_time
    @break_time.break_end_time = break_end_time

    if @timer.save && @break_time.save
      redirect_to change_all_timestamps_path, success: "できたよ"
    else
      flash.now[:error] = "できなかったよ" 
      render :edit_all_timestamps, status: :unprocessable_entity
    end
  end

  private

  def set_team
    @team = Team.find(params[:team_id])
    return if @team.user == current_user || @team.attendees.include?(current_user)

    redirect_to root_path, alert: t('defaults.message.not_authority')
  end
end
