source 'http://rubygems.org'

gem 'rails', '3.0.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
gem 'mysql'
gem 'mysql2'
gem 'carmen'
gem 'ruby-recaptcha' #zainstalowac przez bundlera
=begin
Rafael - doszedłem do tego, że nie trzeba nawet mieć całego ImageMagick ani rmagick :D
Instalacja paperclip:
Wypieprzyć (nie instalować) gem rmagick oraz samego ImageMagick. Zainstalować:	
libmagickcore-dev, libmagickwand-dev, libmagickcore3-extra, libmagickcore3, libmagickwand3
Zainstalować gem paperclip z bundla i nie dodawać żadnych ścieżek ani require w plikach. Jakby nie działało z gemu, to:
rails plugin install git://github.com/thoughtbot/paperclip.git
Działa LOL
=end
#gem 'rmagick'
gem "paperclip", "~> 2.3"

gem 'will_paginate', :git => 'git://github.com/mislav/will_paginate.git', :branch => 'rails3'

gem 'thinking-sphinx',
  :git     => 'git://github.com/freelancing-god/thinking-sphinx.git',
  :branch  => 'rails3',
  :require => 'thinking_sphinx'

gem "jquery-rails"

group :development do
  gem 'faker' #generowanie testowych danych
end

group :test, :development do
  gem "rspec-rails"
  gem "factory_girl"
  #gem "spork"
end
# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end