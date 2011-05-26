#encoding: utf-8
require 'faker'
I18n.locale = :en
#wypelnianie bazy development danymi => rake db:populate

#ilosc generowanych danych

USERS = 10 #UWAGA kazdy uzytkownik to dodatkowe 40 rekordow

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
    make_reputations
    make_relationships
    make_points
    make_blogposts
    make_blogcomments
    make_groups_and_tags
    make_auctions
    make_offers
    make_projects
  end
end

def make_users #zmieniony format emailu dla latwiejszego logowania
  5.times do |i|
  	login = Faker::Internet.user_name
  	description = Faker::Lorem.sentence(12)
    firstname = Faker::Name.first_name
    lastname = Faker::Name.last_name
    country = Carmen.default_country
    user = User.create!(
      :login => login,
      :password => 'password',
      :name => firstname,
      :lastname => lastname,
      :role => 'user',
      :status => 2,
      :country => country,
      :email => "#{i+1}@example.com",
      :description => description
    )
    user.status = 2
	  user.role = "user"
	  user.save
  end
  n = User.count
  USERS.times do |i|
  	login = Faker::Internet.user_name
  	description = Faker::Lorem.sentence(12)
    firstname = Faker::Name.first_name
    lastname = Faker::Name.last_name
    country = Carmen.default_country
    user = User.create!(
      :login => login,
      :password => 'password',
      :name => firstname,
      :lastname => lastname,
      :role => 'user',
      :status => 1,
      :country => country,
      :email => "#{i+n}@example.com",
      :description => description
    )
    user.status = rand(3)
	  user.role = "user"
	  user.save
  end
end

def make_reputations
	zmienna = 2*USERS+1
   	zmienna.times do |i|
   	Reputation.create!(
      :user_id => i+1,
      :reputation => 0
    )
   end
end

def make_relationships
  users = User.all
  user = User.find(2)
  watching = users[3..User.count-1]
  watchers = users[3..User.count-1]
  watching.each { |watched| user.watch!(watched) }
  watchers.each { |watcher| watcher.watch!(user) }
end

def make_blogposts
	User.all(:limit => 11).each do |user|
      50.times do
        user.blogposts.create!(:title => Faker::Lorem.sentence(2), :content => Faker::Lorem.sentence(5))
      end
    end
end

def make_blogcomments
	Blogpost.all(:limit => 11).each do |blogpost|
      50.times do
        blogpost.blogcomments.create!(:content => Faker::Lorem.sentence(5))
      end
    end
end

def make_points
	11.times do |i|		
		Bonuspoint.create!(
		:points => rand(100),
		:user_id => i+1,
		:for_what => rand(3)
		)
	end
end

def make_projects
  all_users = []
  User.where(:status => 2, :role => 'user').each do |u|
    all_users << u.id
  end

  avible_users = []
  project_users = []
  roles = []
  
  Role.all.each do |r|
    unless r.name == 'owner' || r.name == 'leader'
      roles << r.id
      roles << Role.get_id('guest')
    end
  end
  
  all_users.each do |u|
    avible_users = all_users - [u]
    project_users += [u]
    
    #auction
    name = Faker::Lorem.words(3).join(' ').capitalize
    description = Faker::Lorem.sentence(12)
    a = Auction.new(:title => name.capitalize,
                    :budget_id => 1+rand(Budget.count-1),
                    :expired_after => 1+rand(13),
                    :description => description)
    a.owner_id = u
    a.save!
    
    #auction offers
    offerers = avible_users
    5.times do
      offerer = offerers.rand
      break if offerer.nil?
      offerers -= [offerer]
      Offer.create!(:price => 1+rand(10000),
                    :days => 1+rand(31),
                    :offerer_id => offerer,
                    :auction_id => a.id)
    end
    
    won_offer = a.offers.rand
    a.set_won_offer!(won_offer)
    a.finish!
    avible_users -= [won_offer.offerer_id]
    project_users += [won_offer.offerer_id]
    
    #project
    p = Project.create!(:auction_id => a.id,
                        :name => a.title,
                        :owner_id => a.owner_id,
                        :leader_id => won_offer.offerer_id,
                        :duration => won_offer.days,
                        :status => Project::STATUSES[:active],
                        :description => a.description)                
    
    #project members
    4.times do
      new_user = avible_users.rand
      break if new_user.nil?
      avible_users -= [new_user]
      project_users += [new_user]
      
      i = Invitation.new(:project_id => p.id,
                         :user_id => new_user,
                         :role_id => roles.rand,
                         :status => Invitation::STATUSES[:accepted])
      i.save!
                         
      Membership.create!(:user_id => i.user_id,
                         :project_id => i.project_id,
                         :role_id => i.role_id)
    end
    
    ticket_users = project_users - [p.leader_id, p.owner_id]

    #projec tickets
    10.times do
      break if ticket_users.empty?
      title = Faker::Lorem.words(3).join(' ').capitalize
      description = Faker::Lorem.sentences(12).join(' ')
      taken = 50 < rand(100) ? true : false
      finished = 50 < rand(100) ? true : false
      Ticket.create!(:project_id => p.id,
                     :user_id => taken ? ticket_users.rand : nil,
                     :title => title,
                     :description => description,
                     :duration => rand(40)+1,
                     :status => taken ? (finished ? Ticket::STATUSES[:finished] : Ticket::STATUSES[:implementation]) : Ticket::STATUSES[:free])
    end
    
    #project topics
    3.times do
      title = Faker::Lorem.words(3).join(' ').capitalize
      content = Faker::Lorem.sentences(12).join(' ')
      t = Topic.new(:project_id => p.id,
                    :user_id => project_users.rand,
                    :title => title,
                    :content => content)
      t.save!
      #topic posts
      5.times do
        content = Faker::Lorem.sentences(12).join(' ')
        Post.create!(:topic_id => t.id,
                     :user_id => project_users.rand,
                     :content => content)
      end
    end 
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

def make_auctions
  50.times do
    name = "Aukcja " + Faker::Company.name
    description = Faker::Lorem.sentence(12)
    a = Auction.new(
      :title => name, :budget_id => 1+rand(Budget.count-1),
      :expired_after => 1+rand(13), :description => description
    )
    a.owner_id = 1+rand(USERS-1)
    a.save!
  end
end

def make_offers
  50.times do
    Offer.create!(
      :price => 1+rand(10000),
      :days => 1+rand(31),
      :offerer_id => 1+rand(User.count-1),
      :auction_id => 1+rand(Auction.count-1)
    )
    
  end
end
