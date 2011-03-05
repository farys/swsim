require 'faker'
I18n.locale = :en
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
  100.times do |n|
    name = Faker::Company.name
    Project.create!(:name => name, :owner_id => rand(20), :leader_id => rand(100), :duration => rand(370), :status => rand(2) )
  end
end