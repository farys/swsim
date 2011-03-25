module ProjectsHelper
  def can_edit?(page)
  	if @project.active?
	  	case page
	  		when 'info'
	  			@project.user_role(current_user.id).info
	  		when 'user'
	  			@project.user_role(current_user.id).user
	  		when 'forum'
	  			@project.user_role(current_user.id).forum
	  		when 'file'
	  			@project.user_role(current_user.id).file	
	  	end
	  else
	  	false
  	end
  end
end