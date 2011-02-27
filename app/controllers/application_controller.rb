class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :init
  before_filter :check_alerts

  private
  def init
    @global_title = '- inz v0.1'
    @logged_user = User.find(2)#TODO
  end
  
  def login_required
    if @logged_user.nil?
      redirect_to :controller => :users, :action => :login
    end
  end

  def check_alerts
    unless @logged_user.nil?
      @alerts_count = @logged_user.received_alerts.count
    end
  end
end