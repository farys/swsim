require 'faker'

#wypelnianie bazy development danymi => rake db:populate

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_projects
  end
end

def make_users
  96.times do
    name  = Faker::Name.name
    User.create(:login => name, :password => 'password')
  end
end

def make_projects
  Project.create!(:name => 'uber projekt', :owner_id => 2, :leader_id => 1, :deadline => Date.current+14.days, :status => 0 )
  Project.create!(:name => 'wymiatacze', :owner_id => 1, :leader_id => 3, :deadline => Date.current+14.days, :status => 1 )
  Project.create!(:name => 'uber diablo', :owner_id => 4, :leader_id => 5, :deadline => Date.current+14.days, :status => 2 )
end