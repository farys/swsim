class AlertsController < ApplicationController
  skip_before_filter :authenticate

  def create
    session[:back] = request.referer if session[:back].nil?
    params[:alert][:text] = params[:pre_text] + params[:alert][:text]
    @alert = Alert.new params[:alert]
    @alert.author = current_user
    
    if (!current_user.nil? || validate_recap(params, @alert.errors)) && @alert.save
      flash_t :notice
      redirect_to session[:back]
      session[:back] = nil
    else
      render :new
    end
  end
end
