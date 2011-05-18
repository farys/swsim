module ProjectsHelper
  def can_edit?(page)
    if @project.active?
      role = Hash.new(false)
      role.merge! @project.user_role(current_user.id).attributes
      role[page]
	  else
	  	flash_t_general :notice, 'project.not_active'
	  	redirect_to project_info_path(@project)
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
