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
  
  def edit_topic?(topic_id)
  	if can_edit?('forum')
  		true
  	elsif current_user.topic_ids.include?(topic_id) && @project.active?
  		true
  	else
  		false
  	end
  end
  
  def edit_topic?(post_id)
  	if can_edit?('forum')
  		true
  	elsif current_user.post_ids.include?(post_id) && @project.active?
  		true
  	else
  		false
  	end
  end
end