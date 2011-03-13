module ProjectsHelper
  def can_edit?(page)
    "#{@project.user_role(@logged_user.id)}.#{page}"
  end
end