class ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update]
  
  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to profile_path, success: t('defaults.message.updated', item: t('profiles.show.title')) 
    else
      flash.now[:danger] = t('defaults.message.not_updated', item: t('profiles.show.title'))
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user 
  end

  def user_params
    params.require(:user).permit(:name, :description, :avatar, :avatar_cache)
  end
end
