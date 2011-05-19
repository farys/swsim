#require 'mail'
#encoding: utf-8
class Admin::UsersController < Admin::ApplicationController
	before_filter :admin_user
	
	def index
		@title = "Panel administratora: uzytkownicy"
		@users = User.find(:all, :order => "lastname").paginate :per_page => 15, :page => params[:page]	    	
	end
	
	def points
		@user = User.find(params[:id])
		@pointssum = Bonuspoint.find_all_by_user_id(params[:id])
		@points = Bonuspoint.find_all_by_user_id(params[:id]).paginate :per_page => 15, :page => params[:page]
		@title = "Panel administratora: punkty uzytkownika #{@user}"
		
		@suma = 0
      	@pointssum.each do |sum|
      		@suma += sum.points
        end
	end
	
	def editpoints
		@title = "Panel administratora: punkty"
		Bonuspoint.use!(params[:addorremove][:points], params[:id], 4)
		flash[:success] = "Dodano #{params[:addorremove][:points]} punkty"
		redirect_to :action => :points
	end
	
	def destroy
		@title = "Panel administratora: uzytkownicy"
    	@user = User.find_by_id(params[:id])
    	if @user.update_attribute(:status, params[:status])
    		redirect_to "/admin/users"
    		flash[:success] = "Zmieniono status uzytkownika o id: #{@user.id}"
    	end
    end
    
    def blogposts
    	@title = "Panel administratora: blog"
    	@blogposts = Blogpost.find_all_by_admin(1).paginate :per_page => 15, :page => params[:page]
    end
    
    def blogpostedit
    	@title = "Panel administratora: blog || edycja"
    	@blogpost = Blogpost.find(params[:id])
    	@title = "Edycja blogposta o id: #{@blogpost.id}"
    end
    
    def blogpostedit2
    	@title = "Panel administratora: blog"
    	@blogpost = Blogpost.find(params[:id])
    	@blogpost.update_attributes(:title => params[:title][:title], :content => params[:content][:content])
    	redirect_to :action => :blogposts
    end
    
    def deleteblogpost
    	@title = "Panel administratora: blog"
    	@blogpost = Blogpost.find(params[:blogpost])
    	@blogpost.destroy
    	redirect_to :action => :blogposts
    	flash[:success] = "Usunieto posta: #{@blogpost.title}"
    end
    
    def blogcomments
    	@title = "Panel administratora: komentarze"
    	@blogcomments = Blogcomment.find_all_by_admin(1).paginate :per_page => 15, :page => params[:page]
    end
    
    def deleteblogcomment
    	@title = "Panel administratora: komentarze"
    	@blogcomment = Blogcomment.find(params[:blogcomment])
    	@blogcomment.destroy
    	redirect_to :action => :blogcomments
    	flash[:success] = "Usunieto komentarz o id: #{@blogcomment.id}"
    end
    
    private
    
    def admin_user
    	if current_user.status != 2
    		redirect_to root_path
    	end
    end

end
