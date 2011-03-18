module UsersHelper
	
	def escape_user(user)
		image_tag("flags/#{user.country.downcase}.gif") +" "+ user.name
	end
	
end