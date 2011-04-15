#require 'mail'
#encoding: utf-8
class UsersController < ApplicationController
	before_filter :correct_user, :only => [:edit, :update]
	
	$countries = Carmen.countries
	
	def new
		@user = User.new
	end
	
	def show
      @user = User.find(params[:id])
      @projects = Project.find(@user.project_ids).paginate :per_page => 15, :page => params[:page]
      @country_name = Carmen::country_name(@user.country)
      @country_flag = "flags/#{@user.country.downcase}.gif"
    end
	
	def create
    	@user = User.new(params[:user])
    	@hash_mail = make_hash
    	@emailver = Emailver.new(:hash => @hash_mail, :user => @user)
    	if validate_recap(params, @user.errors) && @user.save && @emailver.save
    		Sender.ver_mail(@hash_mail).deliver
    		redirect_to root_path
      		flash_t :notice
    	else
      		render :action => :new
    	end
  	end
  	
  	def edit
  		@user = User.find(params[:id])
  	end
  	
  	def update
  		@user = User.find(params[:id])
    	if params[:user][:password] == ''	
    		params[:user][:password] = @user.password
    		params[:user][:password_confirmation] = @user.password
    	end
	    if @user.update_attributes(params[:user])
	      redirect_to @user
	      flash_t :notice
	    else
	      @title = "Edit user"
	      render :action => :edit
	    end
    end
    
    #sprawdzamy hasha ktorego dostal na skrzynke user
    def mail_ver
    	@hash = Emailver.find_by_hash(params[:hash])
    	if @hash.nil?
    		flash[:error] = "Nie ma takiego uzytkownika!"
    		redirect_to root_path
    	else
    		@user = User.find(@hash.user_id)
    		#TODO napisac zmiane statusu w bazie na aktywny
    		redirect_to user_path(@user)
    		flash[:success] = "OK!"
    	end
    end
    
    def watching
	    @title = "Moi zaufani"
	    @user = User.find(params[:id])
	    @users = @user.watching.paginate(:page => params[:page])
	    render 'show_watch'
    end

    def watchers
	    @title = "Zaufali mi"
	    @user = User.find(params[:id])
	    @users = @user.watchers.paginate(:page => params[:page])
	    render 'show_watch'
    end
    
    def find
    	@fraza = params[:find][:text]
    	@value = params[:szukaj][:user]
    	if @value == "id"
    		@user = User.find_by_id(@fraza)
    	elsif @value == "lastname"
    		@user = User.find_by_lastname(@fraza)
    	elsif @value == "email"
    		@user = User.find_by_email(@fraza)
    	elsif @value == "login"
    		@user = User.find_by_login(@fraza)
    	end
    	if @user.nil?
    			redirect_to user_path(current_user)
    			flash[:error] = "Nie ma takiego uzytkownika"
    	else
    		redirect_to user_path(@user)
    	end
    end

  	
  	private
  	
  	#generowanie hasha, ktory jest wysylany na email uzytkownika przy rejestracji w celu weryfikacji emaila
  	def make_hash
    	chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
	    string = ""
	    20.times do
	    	string << chars[rand(chars.size-1)]
	    end
	    hash = Digest::SHA2.hexdigest(string)
    end
  	
  	def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end