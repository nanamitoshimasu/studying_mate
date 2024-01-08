class Teams::AttendancesController < ApplicationController
  def create
    @team =Team.find(params[:team_id])
    team_attendance = current_user.attend(@team)
    redirect_back(fallback_location: root_path, success: '参加の申込をしました')
  end

  def destroy
    @team = Team.find(params[:team_id])
    current_user.cancel_attend(@team)
    redirect_back(fallback_location: root_path, success: '参加をキャンセルしました')
  end
end
