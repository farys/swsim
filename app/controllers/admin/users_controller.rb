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
		Bonuspoint.use!(params[:addorremove][:points], params[:id], 4)
		@points = Bonuspoint.find_all_by_user_id(params[:id]).paginate :per_page => 15, :page => params[:page]
		render :action => :points
	end
	
	def delete
    	@user = User.find_by_id(params[:id])
    	if @user.update_attribute(:status, params[:status])
    		@users = User.find(:all, :order => "lastname").paginate :per_page => 15, :page => params[:page]
    		render :action => :index
    		flash[:success] = "Zbanowano uzytkownika"
    	end
    end
    
    def blogposts
    	@blogposts = Blogpost.find_all_by_admin(1).paginate :per_page => 15, :page => params[:page]
    end
    
    def blogpostedit
    	@blogpost = Blogpost.find(params[:id])
    end
    
    def blogpostedit2
    	@blogpost = Blogpost.find(params[:id])
    	@blogpost.update_attributes(:title => params[:title][:title], :content => params[:content][:content])
    	@blogposts = Blogpost.find_all_by_admin(1).paginate :per_page => 15, :page => params[:page]
    	render :action => :blogposts
    end
    
    def deleteblogpost
    	@blogpost = Blogpost.find(params[:blogpost])
    	@blogpost.destroy
    	@blogposts = Blogpost.find_all_by_admin(1).paginate :per_page => 15, :page => params[:page]
    	render :action => :blogposts
    end

end