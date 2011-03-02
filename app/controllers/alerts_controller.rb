class AlertsController < ApplicationController
  def create
    @alert = Alert.new params[:alert]
    
    if @alert.save
      redirect_to :back
      flash[:notice] = 'Zgloszenie zostalo przyjete!'
    end
  end
end
