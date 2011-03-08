require 'faker'
I18n.locale = :en
#wypelnianie bazy development danymi => rake db:populate

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_roles
    make_projects
    #make_files
  end
end

def make_users
  96.times do
    name  = Faker::Name.name
    User.create!(:login => name, :password => 'password')
  end
end

def make_projects
  100.times do
    name = Faker::Company.name
    description = Faker::Lorem.sentence(4)
    Project.create!(:name => name, :owner_id => rand(20), :leader_id => rand(100), :duration => rand(370), :description => description )
  end
end

def make_roles
  Role.create!(:name => 'guest')
  Role.create!(:name => 'leader', :file => true, :forum => true, :user => true, :info => true)
  Role.create!(:name => 'info_mod', :info => true)
end

def make_files
  name = Faker::Lorem.words(2)
  type = Faker::Lorem.words(1)
  description = Faker::Lorem.sentence(4)
  ProjectFile.create!(:project_id => rand(50), :user_id => rand(30), :name => name, :size => rand(10**7), :type => type, :description => description)
end