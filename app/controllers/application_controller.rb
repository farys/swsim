class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  layout 'standard'
  
  before_filter :init
  def init
    @global_title = '- Rails_client'
    @logged_user = User.find(1)#todo
  end
  
#todo
  private
  def logging_procedure
    if session[:logged_user].nil?
      redirect_to :controller => :panel, :action => :login
    else
      @logged_user = session[:logged_user]
    end
  end
end