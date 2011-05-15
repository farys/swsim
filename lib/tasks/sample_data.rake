#encoding: utf-8
require 'faker'
I18n.locale = :en
#wypelnianie bazy development danymi => rake db:populate

#ilosc generowoanych danych
USERS = 5
PROJECTS = USERS*5
INVITATIONS = PROJECTS*5
TOPICS = PROJECTS*5
POSTS = TOPICS*5
TICKETS = PROJECTS*5

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
    make_roles
    make_groups_and_tags
    make_auctions
    make_projects
    #make_tickets
    make_offers
    make_comments_keywords
    make_topics
    make_posts
  end
end

def make_users #zmieniony format emailu dla latwiejszego logowania
  USERS.times do |i|
  	description = Faker::Lorem.sentence(12)
    firstname = Faker::Name.first_name
    country = Carmen.default_country
    User.create!(
      :login => "Login_#{i+1}",
      :password => 'password',
      :name => firstname,
      :lastname => "Kowalski_#{i+1}",
      :role => 'user',
      :status => 1,
      :country => country,
      :email => "#{i+1}@inz.pl",
      :description => description
    )
  end
      User.create!(
      :login => "Maveral2",
      :password => 'password',
      :name => "Mariusz",
      :lastname => "Franke",
      :role => 'administrator',
      :status => 2,
      :country => "pol",
      :email => "mav@inz.pl",
      :description => "To ja :)"
    )
end

def make_reputations
   USERS.times do |i|
   	Reputation.create!(
      :user_id => i,
      :reputation => 0
    )
   end
end

def make_relationships
  users = User.all
  user  = users.first
  watching = users[1..User.count-1]
  watchers = users[1..User.count-1]
  watching.each { |watched| user.watch!(watched) }
  watchers.each { |watcher| watcher.watch!(user) }
end

def make_blogposts
	User.all(:limit => 4).each do |user|
      50.times do
        user.blogposts.create!(:title => Faker::Lorem.sentence(2), :content => Faker::Lorem.sentence(5))
      end
    end
end

def make_blogcomments
	Blogpost.all(:limit => 4).each do |blogpost|
      50.times do
        blogpost.blogcomments.create!(:content => Faker::Lorem.sentence(5))
      end
    end
end

def make_points
	50.times do
		Bonuspoint.create!(
		:points => rand(100),
		:user_id => 1,
		:for_what => rand(3)
		)
	end
end

def make_projects
  PROJECTS.times do
    name = Faker::Company.name
    description = Faker::Lorem.sentences(12)
    Project.create!(
    	:name => name,
    	:owner_id => rand(User.count-1)+1,
    	:leader_id => rand(User.count-1)+1,
    	:auction_id => rand(Auction.count-1)+1,
    	:duration => rand(370),
    	:description => description
    )
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
  Role.create!(:name => 'leader', :file => true, 
                                  :forum => true,
                                  :member => true,
                                  :info => true,
                                  :invitation => true,
                                  :ticket => true)
  Role.create!(:name => 'owner', :info => true)
  Role.create!(:name => 'info_mod', :info => true)
  Role.create!(:name => 'inv_mod', :invitation => true)
  Role.create!(:name => 'member_mod', :member => true)
  Role.create!(:name => 'ticket_mod', :ticket => true)
  Role.create!(:name => 'file_mod', :file => true)
  Role.create!(:name => 'forum_mod', :forum => true)
  
end

def make_auctions
  100.times do
    name = "Aukcja " + Faker::Company.name
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

def make_comments_keywords
  CommentKeyword.create!(
    [{ :name => "Kontakt" },
    { :name => "Realizacja" },
    { :name => "Stosunek do użytkownika" }
    ])

end

def make_topics
	TOPICS.times do
		title = Faker::Lorem.words(3).join(' ')
		content = Faker::Lorem.sentences(12)
		topic = Topic.create!(:project_id => rand(Project.count-1)+1,
													:user_id => rand(User.count-1)+1,
													:title => title,
													:content => content)
	end
end

def make_posts
	POSTS.times do
		content = Faker::Lorem.sentences(12)
		Post.create!(:topic_id => rand(Topic.count-1)+1,
								 :user_id => rand(User.count-1)+1,
								 :content => content)
	end
end

def make_tickets
  TICKETS.times do
    title = Faker::Lorem.words(3).join(' ')
		content = Faker::Lorem.sentences(12)
    Ticket.create!(:project_id => rand(Project.count-1)+1,
                   :title => title,
									 :description => content,
									 :duration => rand(23)+1,
									 :status => 0)
  end
end
