class SessionsController < ApplicationController
  def new
  	@title = "Logowanie"
  end
  
  def create
  	@title = "Logowanie"
  	user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash_t :error, 'login_error'
      render 'new'
    elsif user.status == 0
    	flash_t :error, 'deactivated'
      render 'new'
      elsif user.status == 1
    	flash_t :error, 'niezweryfikowany'
      render 'new'
    elsif user.status == 3
    	flash_t :error, 'ban'
      render 'new'
    elsif validate_recap(params, user.errors) == false
    	flash_t :error, 'captcha'
      render 'new'
    else
      sign_in user
      reputation
      if current_user.role == "administrator"
        redirect_to admin_users_path
      else
        redirect_back_from_login session
      end
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
    flash_t :notice
  end
  
  private
  
  def reputation
  		
  	  #suma punktow za aukcje
  	  @reputation_user = Reputation.find_or_create_by_user_id(current_user)
  	  
  	  @auctionsratings = Comment.find_all_by_receiver_id_and_status_and_level(current_user, 0, 0, :select => "id")
  	  @how_many_auctions = @auctionsratings.count
      @auctionsratings2 = CommentValue.find_all_by_comment_id(@auctionsratings, :select => "rating")
      @suma = 0
      @auctionsratings2.each do |sum|
      	@suma += sum.rating
      end
      
      #suma punktow za projekty
      @commentsratings = Comment.find_all_by_receiver_id_and_status_and_level(current_user, 0, 1, :select => "id")
      @how_many_comments = @commentsratings.count
      @commentsratings2 = CommentValue.find_all_by_comment_id(@commentsratings, :select => "rating")
      @suma2 = 0
      @commentsratings2.each do |sum|
      	@suma2 += sum.rating
      end
      
      #średnia suma punktow za kontakt
      @kontaktrating = CommentValue.find_all_by_comment_id_and_keyword_id(@commentsratings, 1, :select => "rating")
      @suma3 = 0
      @kontaktrating.each do |sum|
      	@suma3 += sum.rating
      end
      
      if @kontaktrating.count != 0
      	@suma3 /= @kontaktrating.count
      end
      
      #średnia suma punktow za realizacje
      @realizacjarating = CommentValue.find_all_by_comment_id_and_keyword_id(@commentsratings, 2, :select => "rating")
      @suma4 = 0
      @realizacjarating.each do |sum|
      	@suma4 += sum.rating
      end
      
      if @realizacjarating.count != 0
      @suma4 /= @realizacjarating.count
      end
      
      #średnia suma punktow za stosunek do pracy
      @stosunekrating = CommentValue.find_all_by_comment_id_and_keyword_id(@commentsratings, 3, :select => "rating")
      @suma5 = 0
      @stosunekrating.each do |sum|
      	@suma5 += sum.rating
      end
      
      if @stosunekrating.count != 0
      @suma5 /= @stosunekrating.count
      end
      
      #Calosciowa reputacja
      if @commentsratings2.count == 0
      	@suma6 = 0
      elsif
      	@suma6 = ((@suma2/(5*(@commentsratings2.count)).to_f)*100).round(2) #srednia z ocen czastkowych
      end
      
      if @auctionsratings2.count == 0
      	@suma7 = 0
      elsif
      	@suma7 = ((@suma/(5*(@auctionsratings2.count)).to_f)*100).round(2)
      end
      
      if @commentsratings2.count == 0 && @auctionsratings2.count == 0
      	@reputation = 0
      elsif (@commentsratings2.count != 0 && @auctionsratings2.count == 0) || (@commentsratings2.count == 0 && @auctionsratings2.count != 0)
      	@reputation = @suma6+@suma7
      else
      	@reputation = ((@suma7+@suma6)/2).round(2)
      end
      
      @reputation_user.update_attributes(:reputation => @reputation, :user_id => current_user.id, :finished_auctions => @how_many_auctions, :auctions_overall_ratings => @suma, :rated_projects => @how_many_comments, :projects_overall_ratings => @suma2, :average_contact => @suma3, :average_realization => @suma4, :average_attitude => @suma5)
      
  	end

end
