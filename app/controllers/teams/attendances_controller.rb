class Teams::AttendancesController < ApplicationController
  def create
    @team = Team.find(params[:team_id])
    team_attendance = current_user.attend(@team)
    if team_attendance.save
      redirect_back(fallback_location: root_path, success: '参加の申込をしました')
    else
      redirect_back(fallback_location: root_path, alert: team_attendance.errors.full_messages)
    end
  end

  def destroy
    @team = Team.find(params[:team_id])
    current_user.cancel_attend(@team)
    redirect_back(fallback_location: root_path, success: '参加をキャンセルしました')
  end
end
