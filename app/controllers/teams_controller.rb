class TeamsController < ApplicationController
  skip_before_action :check_logged_in, only: %i[index show]

  def index
    @q = Team.ransack(params[:q])
    @teams = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page]).per(4)
  end

  def show
    @team = Team.find(params[:id])
  end

  def new
    @team = Team.new
  end

  def edit
    @team = current_user.teams.find(params[:id])
  end

  def create
    @team = current_user.teams.build(team_params)
    if @team.save
      @team.attendees << current_user
      redirect_to teams_path, success: t('defaults.message.created', item: t('teams.new.title'))
    else
      flash.now[:error] = t('defaults.message.not_created', item: t('teams.new.title'))
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @team = current_user.teams.find(params[:id])
    if @team.update(team_params)
      redirect_to team_path(@team)
    else
      flash.now[:error] = t('defaults.message.not_updated', item: t('teams.new.title'))
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @team = current_user.teams.find(params[:id])
    @team.destroy!
    redirect_to teams_path, success: t('defaults.message.deleted', item: t('teams.new.title')), status: :see_other
  end

  def member_page
    @team = Team.find(params[:id])
    @room = @team.room
    @messages = @room.messages if @room.present?

    @active_team = current_user.attend_teams.where('start_date <= ? AND end_date >= ?', Time.current, Time.current).order(:end_date).last
    if @active_team.blank?
      @previous_team = current_user.attend_teams.where('end_date < ?', Time.current).order(:end_date).last
    end
    return if current_user.attend?(@team)

    redirect_to root_path, alert: t('defaults.message.attend_teams')
  end

  private

  def team_params
    params.require(:team).permit(:title, :description, :capacity, :target_time, :start_date, :end_date, :thumbnail,
                                 :thumbnail_cache)
  end
end
