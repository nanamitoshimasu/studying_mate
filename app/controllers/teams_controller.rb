class TeamsController < ApplicationController
  skip_before_action :check_logged_in, only: %i[index show]

  def index
    @teams = Team.all.includes(:user).order(created_at: :desc).page(params[:page]).per(4)
  end

  def new
    @team = Team.new
  end

  def create
    @team = current_user.teams.build(team_params)
    if @team.save
      @team.attendees << current_user
      redirect_to teams_path, success: t('defaults.message.created', item: t('team.model_name.human'))
    else
      flash.now[:error] = t('defaults.message.not_created', item: t('team.model_name.human')) 
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @team = Team.find(params[:id])
  end

  def edit
    @team = current_user.teams.find(params[:id])
  end

  def update
    @team = current_user.teams.find(params[:id])
    if @team.update(team_prams)
      redirect_to team_path(@team)
    else
      flash.now[:error] = t('defaults.message.not_updated', item: t('team.model_name.human')) 
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @team = current_user.teams.find(params[:id])
    @team.destroy!
    redirect_to teams_path, success: t('defaults.message.deleted', item: t('team.model_name.human')), status: :see_other
  end
  
  def member_page
    @team = Team.find(params[:id])
    @is_activity_period = @team.start_date <= Time.current && Time.current <= @team.end_date
    unless current_user.attend?(@team) && @is_activity_period
      redirect_to root_path, alert: 'まだチームに参加していないようですね？チームに参加しましょう！'
    end
    @active_team = current_user.attend_teams.where('start_date <= ? AND end_date >= ?', Time.current, Time.current).order(:end_date).last
    @previous_team = current_user.attend_teams.where('end_date < ?', Time.current).order(:end_date).last unless @active_team.present?
  end 
  
  private

  def team_params
    params.require(:team).permit(:title, :description, :capacity, :target_time, :start_date, :end_date, :thumbnail, :thumbnail_cache)
  end
end
