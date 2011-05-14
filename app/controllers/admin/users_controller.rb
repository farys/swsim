#require 'mail'
#encoding: utf-8
class Admin::UsersController < Admin::ApplicationController
	before_filter :correct_user, :only => [:edit, :update]
	
	def index
		@users = User.find(:all, :order => "lastname").paginate :per_page => 15, :page => params[:page]	    	
	end
	
	def points
		@points = Bonuspoint.find_all_by_user_id(params[:id]).paginate :per_page => 15, :page => params[:page]
	end
	
	def editpoints
		@lol = (params[:addorremove][:points])
		Bonuspoint.use!(@lol, params[:id], 4)
		@points = Bonuspoint.find_all_by_user_id(params[:id]).paginate :per_page => 15, :page => params[:page]
		render :action => :points
	end

end