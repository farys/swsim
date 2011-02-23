class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  layout 'standard'

  before_filter :init

#todo
  private
  def init
    @global_title = '- inz v0.1'
    @logged_user = User.find(2)#todo
  end
  
  def login_required
    if @logged_user.nil?
      redirect_to :controller => :users, :action => :login
    end
    
#    if params.has_key?(:user_id) && (not @logged_user.id.eql?(params[:user_id]))
#      redirect_to panel_user_path(@logged_user)
#    end
  end
  
  #TODO cos z tym zrobic 
  def logging_procedure
    if session[:logged_user].nil?
      redirect_to :controller => :panel, :action => :login
    else
      @logged_user = session[:logged_user]
    end
  end
end