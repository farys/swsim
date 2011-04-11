# encoding: utf-8
class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionsHelper
  include ReCaptcha::AppHelper
  protect_from_forgery

  before_filter :authenticate
  before_filter :init
  #before_filter :check_alerts

  private
  def init
    @global_title = '- inz v0.1'
  end 
   
=begin
=======
    @logged_user = User.find(1)#TODO
  end
  

  def login_required
    if current_user.nil?
      redirect_to signin_path, :notice => "Wpierw musisz sie zalogowac"
    end
  end

  def check_alerts
    unless current_user.nil?
      @alerts_count = current_user.received_alerts.count
    end
  end
=end

  def flash_t(type = nil, action = nil)
    params = request.parameters.clone
    params["controller"]["/"] = "." if params["controller"].include?("/")
    if action.nil?
    	text = t("flash.#{params["controller"]}.#{params[:action]}")
    else
    	text = t("flash.#{params["controller"]}.#{action}")
    end
    return text if type.nil?
    flash[type] = text
  end
  
  def flash_t_general(type = nil, action = nil)
    text = t("flash.general.#{action}")
    return text if type.nil? && action.nil?
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
