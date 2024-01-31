class TopsController < ApplicationController
  skip_before_action :check_logged_in, only: :index
  
  def index
    if logged_in?
      @active_team = current_user.attend_teams.where('start_date <= ? AND end_date >= ?', Time.current, Time.current)
    end
  end
end
