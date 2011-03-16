# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Inz::Application.initialize!
$countries = Carmen.countries
Paperclip.options[:command_path] = 'C:\ImageMagick'
Paperclip.options[:image_magick_path] = 'C:\ImageMagick'