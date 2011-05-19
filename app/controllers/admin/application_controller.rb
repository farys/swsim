class Admin::ApplicationController < Panel::ApplicationController
  	before_filter :admin_check
  
	def admin_check
		if current_user.role != "administrator"
  			redirect_to root_path
  			flash[:error] = "Nie jestes administratorem"
		end
	end

end