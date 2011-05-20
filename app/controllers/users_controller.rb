#require 'mail'
#encoding: utf-8
class UsersController < ApplicationController
	before_filter :correct_user, :only => [:edit, :update]
	
	$countries = Carmen.countries
	
	def new
		@title = "Rejestracja"
		@user = User.new
		if User.exists?(:id => params[:ref_id])
			@referer = User.find(params[:ref_id])
    else
      @referer = ""
      render :action => :new
    end
	    
	    	
	end
	
	def show
    @user = User.find(params[:id])
    @statuses = ["Dezaktywowane", "Niezweryfikowane", "Zweryfikowane", "Zbanowane"]
    @title = "Panel uzytkownika #{@user.name} #{@user.lastname}"
    @projects = Project.find(@user.project_ids).paginate :per_page => 15, :page => params[:page]
    @country_name = Carmen::country_name(@user.country)
    @country_flag = "flags/#{@user.country.downcase}.gif"
    @points = Bonuspoint.find_all_by_user_id(@user, :select => "points")
    sum_points
    @reputation = Reputation.find_by_user_id(@user.id)
  end
	
	def create
    @title = "Rejestracja"
    @user = User.new(params[:user])
    @referential = User.find_by_login(params[:ref])
    	
    @hash_mail = make_hash
    if validate_recap(params, @user.errors) && @user.save
      @emailver = Emailver.new(:hash => @hash_mail, :user_id => @user.id)
      if @emailver.save
        Reputation.create!(:user_id => @user.id, :finished_auctions => 0, :auctions_overall_ratings => 0, :rated_projects => 0, :projects_overall_ratings => 0, :average_contact => 0, :average_realization => 0, :average_attitude => 0, :reputation => 0)
        Sender.ver_mail(@hash_mail).deliver
      end
      if @referetnial == "" || @referential == nil
        redirect_to root_path
        flash_t :notice
      else
        Bonuspoint.use!(20, @referential.id, 2)
        redirect_to root_path
        flash_t :notice
      end
    else
      render :action => :new
    end
  end
  	
  def edit
  	@title = "Edycja danych"
    @user = User.find(params[:id])
  end
  	
  def update
    @user = User.find(params[:id])
    if params[:user][:password] == ''
      @title = "Edit user"
      flash[:error] = "Haslo nie moze byc puste"
      render :action => :edit
    elsif @user.update_attributes(params[:user])
      redirect_to @user
      flash_t :notice
    else
      @title = "Edit user"
      render :action => :edit
    end
  end
    
  def destroy
    @user = User.find_by_id(params[:id])
		if @user.update_attribute(:status, params[:status])
      sign_out
      redirect_to root_path
      flash[:success] = "Usunieto uzytkownika"
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
      @user.update_attribute(:status, 2)
      redirect_to root_path
      flash[:success] = "Zweryfikowano!"
    end
  end
    
  def watching
    @user = User.find(params[:id])
    @title = "#{@user.name} #{@user.lastname} || Zaufani"
    @users = @user.watching.paginate(:page => params[:page])
    render 'show_watch'
  end

  def watchers
    @user = User.find(params[:id])
    @title = "#{@user.name} #{@user.lastname} || Zaufali mi"
    @users = @user.watchers.paginate(:page => params[:page])
    render 'show_watch'
  end
    
  def find
    @title = "Find"
    @fraza = params[:find][:text]
    @value = params[:szukaj][:user]
    if @value == "id"
      @findusers = User.find_all_by_id(@fraza)
    elsif @value == "lastname"
      @arrayforname = @fraza.split(/ /)
      @findusers = User.find_all_by_lastname_and_name(@arrayforname[0], @arrayforname[1])
      if @findusers.empty?
        @findusers = User.find_all_by_name_and_lastname(@arrayforname[0], @arrayforname[1])
      end
    elsif @value == "email"
      @findusers = User.find_all_by_email(@fraza)
    elsif @value == "login"
      @findusers = User.find_all_by_login(@fraza)
    end

    respond_to do |format|
      format.html do
        if @findusers.empty?
          redirect_to :back
          flash[:error] = "Nie ma takiego uzytkownika"
        else
        render '_user'
        end
      end
      format.js  { render '_user2' }
    end
  end

  	
  private
  	
  def sum_points
    @pts = 0
    @points.each do |points|
      @pts += points.points
    end
  end
  	
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
    redirect_to(root_path) unless current_user?(@user) || current_user.role == "administrator"
  end
end
