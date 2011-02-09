class AlertsController < ApplicationController
  def create
    params[:alert][:text] = params[:pre_text] + params[:alert][:text]
    @alert = Alert.new params[:alert]
    
    if @alert.save
      redirect_to :back
      flash[:notice] = 'Zgłoszenie zostało przyjęte!'
    end
  end
end
