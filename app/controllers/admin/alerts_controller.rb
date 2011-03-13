class AlertsController < ApplicationController
  before_filter :load_alert, :only => [:show, :destroy]

  def index
    @alerts = Alert.all
  end

  def received
    @alerts = @current_user.received_alerts
  end

  def show
    if @alert.author.eql(@current_user)
      @alert.read!
    end
  end

  def destroy
    @alert.destroy
    flash[:notice] = "Powiadomienie zostalo usuniete"
    redirect_to :back
  end

  private
  def load_alert
    @alert = Alert.find(params[:id])
  end
end
