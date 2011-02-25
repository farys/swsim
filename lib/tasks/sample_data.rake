require 'faker'

#wypelnianie bazy development danymi => rake db:populate

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
  end
end

def make_users
  96.times do
    name  = Faker::Name.name
    User.create(:login => name, :password => 'password')
  end
end