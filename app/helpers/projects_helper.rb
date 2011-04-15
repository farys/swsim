module ProjectsHelper
  def can_edit?(page)
  	if @project.active?
	  	case page
	  		when 'info'
	  		  @project.user_role(current_user.id).info
	  		when 'invitation'
	  		  @project.user_role(current_user.id).invitation	
	  		when 'member'
	  		  @project.user_role(current_user.id).member
	  		when 'ticket'
	  		  @project.user_role(current_user.id).ticket
	  		when 'forum'
	  		  @project.user_role(current_user.id).forum
	  		when 'file'
	  		  @project.user_role(current_user.id).file
	  		else
	  		  false		
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
  
  def edit_post?(post_id)
  	if can_edit?('forum')
  		true
  	elsif current_user.post_ids.include?(post_id) && @project.active?
  		true
  	else
  		false
  	end
  end
end
