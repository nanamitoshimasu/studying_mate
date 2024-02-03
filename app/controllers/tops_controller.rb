class TopsController < ApplicationController
  skip_before_action :check_logged_in, only: :index
  
  def index
    # 最後に参加したチームを取得するロジック
    if logged_in?
      @active_team = current_user.attend_teams.where('start_date <= ? AND end_date >= ?', Time.current, Time.current).order(:end_date).last
      @previous_team = current_user.attend_teams.where('end_date < ?', Time.current).order(:end_date).last unless @active_team.present?
    end
  end
end
