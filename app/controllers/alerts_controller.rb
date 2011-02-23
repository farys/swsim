class AlertsController < ApplicationController
  def create
    @alert = Alert.new params[:alert]
    
    if @alert.save
      redirect_to :back
      flash[:notice] = 'Zgłoszenie zostało przyjęte!'
    end
  end
end
