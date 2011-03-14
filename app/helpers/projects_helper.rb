module ProjectsHelper
  def can_edit?(page)
    "#{@project.user_role(current_user.id)}.#{page}"
  end
end