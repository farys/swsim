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

  def flash_t type=nil
    params = request.parameters.clone
    params["controller"]["/"] = "." if params["controller"].include?("/")
    text = t("flash.#{params["controller"]}.#{params[:action]}")
    return text if type.nil?
    flash[type] = text
  end

  def title_t action=nil
    action ||= request.parameters["action"].clone
    controller = request.parameters["controller"].clone
    
    controller["/"] = "." if controller.include?("/")
    title = t("title.#{controller}.#{action}")

    title.scan(/{[^}]+}/).each do |var|
      title[var] = eval("->"+var+".call").to_s
    end

    @title = title
  end
end
