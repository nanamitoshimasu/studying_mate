class UsersController < ApplicationController

  def destroy
    @user.destroy
  end
end
