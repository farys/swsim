#require 'mail'
#encoding: utf-8
class UsersController < ApplicationController
	before_filter :correct_user, :only => [:edit, :update]
	
	$countries = Carmen.countries
	
	def new
		@user = User.new
		if User.exists?(:id => params[:ref_id])
			@referer = User.find_by_id(params[:ref_id], :select => ["id", "login"])
	    else
	    	@referer
	    	render :action => :new
	    end
	    	
	end
	
	def show
      @user = User.find(params[:id])
      @statuses = ["Dezaktywowane", "Niezweryfikowane", "Zweryfikowane"]
      @title = "Panel uzytkownika #{@user.name} #{@user.lastname}"
      @projects = Project.find(@user.project_ids).paginate :per_page => 15, :page => params[:page]
      @country_name = Carmen::country_name(@user.country)
      @country_flag = "flags/#{@user.country.downcase}.gif"
      @points = Bonuspoint.find_all_by_user_id(@user, :select => "points")
      sum_points
      reputation
    end
	
	def create
    	@user = User.new(params[:user])
    	@hash_mail = make_hash
    	@emailver = Emailver.new(:hash => @hash_mail, :user => @user)
    	if validate_recap(params, @user.errors) && @user.save && @emailver.save
    		Sender.ver_mail(@hash_mail).deliver
    		if params[:ref_id] != ""
    		Bonuspoint.use!(20, params[:ref_id], 2)
    		#Bonuspoint.create!(:points => 20, :user_id => params[:ref_id], :for_what => 2)
    		end
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
    
    def delete
    	@user = User.find_by_id(params[:user_id])
    	if @user.update_attribute(:status, params[:status])
    		redirect_to @user
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
    		#TODO napisac zmiane statusu w bazie na aktywny
    		redirect_to user_path(@user)
    		flash[:success] = "OK!"
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
    	@user = current_user
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
    	if @findusers.empty?
    			redirect_to user_path(current_user)
    			flash[:error] = "Nie ma takiego uzytkownika"
    	else
    		#redirect_to user_path(@user)
    		respond_to do |format|
  				format.html { render '_user' }
  				format.xml  { render '_user2' }
			end
    	end
    end

  	
  	private
  	
  	def sum_points
  	  @pts = 0
      @points.each do |points|
        @pts += points.points
      end
  	end
  	
  	def reputation
  	  @auctionsratings = Auction.find_all_by_owner_id_and_status(@user, 1, :select => "id")
  	  @how_many_auctions = @auctionsratings.count
      @auctionsratings2 = AuctionRating.find_all_by_auction_id(@auctionsratings, :select => "value")
      @suma = 0
      @auctionsratings2.each do |sum|
      	@suma += sum.value
      end
      
      @commentsratings = Comment.find_all_by_receiver_id(@user, :select => "id")
      @how_many_comments = @commentsratings.count
      @commentsratings2 = CommentValue.find_all_by_comment_id(@commentsratings, :select => "rating")
      @suma2 = 0
      @commentsratings2.each do |sum|
      	@suma2 += sum.rating
      end
      @reputation = (((@suma+@suma2)/(@how_many_auctions+@how_many_comments))/0.05).round
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
      redirect_to(root_path) unless current_user?(@user)
    end
end