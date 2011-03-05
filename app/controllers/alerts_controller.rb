class AlertsController < ApplicationController
  def create
    @alert = Alert.new params[:alert]
    
    if @alert.save
      flash_t :notice
      redirect_to :back
    end
  end
end
