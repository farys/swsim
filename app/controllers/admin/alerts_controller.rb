class Admin::AlertsController < Admin::ApplicationController
  before_filter :load_alert, :only => [:show, :destroy]

  def index
    title_t
    @alerts = Alert.order("id DESC").paginate(:page => params[:page], :per_page => 10)
  end

  def show
    title_t
    if @alert.status == Alert::STATUSES[:unread]
      @alert.read!
    end
  end

  def destroy
    @alert.destroy
    flash_t :notice
    respond_to do |format|
      format.html { redirect_to admin_alerts_path }
      format.js
    end
  end

  private
  def load_alert
    @alert = Alert.find(params[:id])
  end
end
