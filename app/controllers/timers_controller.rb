class TimersController < ApplicationController
  before_action :set_team
  before_action :set_timer, only: %i[edit_all_timestamps update_all_timestamps]

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
      render json: { timer: @timer, calculated_time: @timer.calculated_time, persisted: @timer.persisted? }, status: :ok
    else
      render json: @timer.errors, status: :unprocessable_entity
    end
  end

  def edit_all_timestamps
  end

  def update_all_timestamps

    # Timerの時刻を更新
    start_time = Time.zone.local(*params[:timer].values_at('start_time(1i)', 'start_time(2i)', 'start_time(3i)', 'start_time(4i)', 'start_time(5i)'))
    end_time = Time.zone.local(*params[:timer].values_at('end_time(1i)', 'end_time(2i)', 'end_time(3i)', 'end_time(4i)', 'end_time(5i)'))
    @timer.start_time = start_time
    @timer.end_time = end_time
    save_success = @timer.save

    # break_timeが存在するかどうか確認
    if params[:break_time].present?
      params[:break_time].each do |id, break_time_params|
        break_time = @timer.break_times.find(id)

        # break_timeの時刻を更新
        break_start_time = Time.zone.local(*break_time_params.values_at('break_start_time(1i)', 'break_start_time(2i)', 'break_start_time(3i)', 'break_start_time(4i)', 'start_time(5i)').map(&:to_i))
        break_end_time = Time.zone.local(*break_time_params.values_at('break_end_time(1i)', 'break_end_time(2i)', 'break_end_time(3i)', 'break_end_time(4i)', 'break_end_time(5i)').map(&:to_i))
        break_time.break_start_time = break_start_time
        break_time.break_end_time = break_end_time
        save_success &= break_time.save
      end
    end

    if save_success 
      render json: { status: "success", calculated_time: @timer.calculated_time }, status: :ok
    else
      render json: { status: "error", errors: @timer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_team
    @team = Team.find(params[:team_id])
    return if @team.user == current_user || @team.attendees.include?(current_user)

    redirect_to root_path, alert: t('defaults.message.not_authority')
  end

  def set_timer
    @timer = Timer.find(params[:id])
  end
end
