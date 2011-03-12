#encoding: utf-8
require 'faker'
I18n.locale = :en
#wypelnianie bazy development danymi => rake db:populate

namespace :db do

  desc "Reset the base after changes in migration"
  task :reload => :environment do
    File.delete("db/schema.rb") if File.exist?("db/schema.rb")
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:populate'].invoke
  end

  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_roles
    make_projects
    #make_files
    make_groups_and_tags
    make_auctions
    make_offers
  end
end

def make_users
  96.times do |i|
    login  = Faker::Name.first_name
    firstname = Faker::Name.first_name
    country = Carmen.default_country
    email = Faker::Internet.email
    User.create!(:login => "Login_#{i+1}", :password => 'password', :name => firstname, :lastname => "Kowalski_#{i+1}", :role => 'user', :status => 1, :country => country, :email => email)
  end
end

def make_projects
  100.times do
    name = Faker::Company.name
    description = Faker::Lorem.sentence(4)
    Project.create!(:name => name, :owner_id => rand(20), :leader_id => rand(100), :duration => rand(370), :description => description )
  end
end

def make_groups_and_tags
  g_status = Group::STATUSES[:active]
  programowanie = Group.create(:name => "Programowanie", :status => g_status)
  grafika = Group.create(:name => "Grafika", :status => g_status)

  prog_tags = ["ASP", "Assembler", "C#", "C / C++", "Obj-C", "Delphi",
    "Inne", "Java", "Perl", "PHP",
    "Python", "Ruby"]

  grafika_tags = ["Video", "CI", "Grafika 3D", "Logotypy", "Retusz zdjec",
    "Flash", "Banery", "Broszury", "Wizytowki", "Inne", "Layouty stron",
    "Fotografia"]

  tags_list = {
    programowanie => prog_tags,
    grafika => grafika_tags
  }
  
  while (link = tags_list.shift).is_a?(Array) do
    group = link.shift
    link.shift.each do |tag|
      Tag.create( :name => tag, :group_id => group.id, :status => Tag::STATUSES[:active])
    end
  end
end

def make_roles
  Role.create!(:name => 'guest')
  Role.create!(:name => 'leader', :file => true, :forum => true, :user => true, :info => false)
  Role.create!(:name => 'owner', :info => true)
  Role.create!(:name => 'info_mod', :info => true)
end

def make_files
  name = Faker::Lorem.words(2)
  type = Faker::Lorem.words(1)
  description = Faker::Lorem.sentence(4)
  ProjectFile.create!(:project_id => rand(50), :user_id => rand(30), :name => name, :size => rand(10**7), :type => type, :description => description)
end

def make_auctions
  100.times do
    name = Faker::Company.name
    description = Faker::Lorem.sentence(12)
    Auction.create!(
      :title => name, :budget_id => 1+rand(Budget.ids.size-1),
      :owner_id => 1+rand(User.count-1), :expired_after => 1+rand(13),
      :description => description
    )
    
  end
end

def make_offers
  100.times do
    Offer.create!(
      :price => 1+rand(10000),
      :days => 1+rand(31),
      :offerer_id => 1+rand(User.count-1),
      :auction_id => 1+rand(Auction.count-1)
    )
    
  end
end