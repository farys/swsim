class SessionsController < ApplicationController
  def new
  	@title = "Logowanie"
  end
  
  def create
  	@title = "Logowanie"
  	user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."     
      render 'new'
    elsif user.status == 0
    	flash.now[:error] = "To konto zostalo zdeaktywowane"
      render 'new'
    else
      sign_in user
      redirect_back_from_login session
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
    flash_t :notice
  end

end