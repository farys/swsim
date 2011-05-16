source 'http://rubygems.org'

gem 'rails', '3.0.3'
gem 'mysql'
gem 'mysql2'
gem 'carmen'
gem 'ruby-recaptcha'
gem 'mail'
gem "paperclip", "~> 2.3"
gem "will_paginate", "~> 3.0.pre2"
gem 'thinking-sphinx', '2.0.3'
gem "jquery-rails"

group :development do
  gem 'faker'
end

group :test, :development do
  gem "rspec-rails"
  gem "factory_girl"
  #gem "spork"
end

=begin
Yakob
ogolnie wszystko w tym komentarzy jest do usuniecia, Raphael sprawdz czy 'nowy' sphinx dziala
poki co zostawiam to bo plik nalezy wyczyscic, to niech kazdy usunie to co jest zbedne a dodal ;p
opis instalacji paperclika na razie zostawic (przyda sie do pracy :P)

Rafael - doszedłem do tego, że nie trzeba nawet mieć całego ImageMagick ani rmagick :D
Instalacja paperclip:
Wypieprzyć (nie instalować) gem rmagick oraz samego ImageMagick. Zainstalować:	
libmagickcore-dev, libmagickwand-dev, libmagickcore3-extra, libmagickcore3, libmagickwand3
Zainstalować gem paperclip z bundla i nie dodawać żadnych ścieżek ani require w plikach. Jakby nie działało z gemu, to:
rails plugin install git://github.com/thoughtbot/paperclip.git
Działa LOL
#gem 'rmagick'

gem 'thinking-sphinx',
  :git     => 'git://github.com/freelancing-god/thinking-sphinx.git',
  :branch  => 'rails3',
  :require => 'thinking_sphinx'
  
=end
