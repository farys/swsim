class UsersController < ApplicationController
  def panel
    #todo ACL, /users/panel/ /users/1/panel
    @user = @logged_user
  end

  def show

  end

end
