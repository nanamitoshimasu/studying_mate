class SessionsController < ApplicationController
  skip_before_action :check_logged_in, only: :create

  def create
    user = User.find_or_create_from_auth_hash(auth_hash)
    if user.save
      cookies.encrypted[:user_id] = user.id
      log_in user
      redirect_back_or_to root_path, success: "ログインしました"
    else
      flash[:error] = "ログインできませんでした" 
      redirect_to root_path
    end
  end
   
  def destroy
    log_out
    redirect_to root_path, success: "ログアウトしました"
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
