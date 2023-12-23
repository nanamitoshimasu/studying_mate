class TeamsController < ApplicationController
  skip_before_action :check_logged_in, only: %i[index show]

  def index
    @team = Team.all
  end

  def new
    @team = Team.new
  end

  def create
    @team = current_user.teams.build(team_params)
    if @team.save
      redirect_to team_path(@team), success: t('defaults.message.created', item: t('team.model_name.human'))
    else
      flash.now[:error] = t('defaults.message.not_created', item: t('team.model_name.human')) 
      render :new
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
      render :edit
    end
  end

  def destroy
    @team = current_user.teams.find(params[:id])
    @team.destroy!
    redirect_to teams_path, success: t('defaults.message.deleted', item: t('team.model_name.human'))
  end

  private

  def team_params
    params.require(:team).permit(:title, :description, :capacity, :target_time, :start_date, :end_date, :thumbnail, :thumbnail_cache)
  end
end
