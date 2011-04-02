#encoding: utf-8
require 'faker'
I18n.locale = :en
#wypelnianie bazy development danymi => rake db:populate

#ilosc generowoanych danych
USERS = 15
PROJECTS = USERS*3
FILES = PROJECTS*3
TOPICS = PROJECTS*3
POSTS = TOPICS*3

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
    make_groups_and_tags
    make_auctions
    make_projects
    make_files
    make_offers
    make_comments_keywords
    #make_topics
    #make_posts
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
  Role.create!(:name => 'leader', :file => true, :forum => true, :user => true, :info => true)
  Role.create!(:name => 'owner', :info => true)
  Role.create!(:name => 'info_mod', :info => true)
end

def make_files
  types = %w[pdf zip rar 7z doc docx jpg jpeg tar tar.bz2 png]
  FILES.times do
  	name = Faker::Lorem.words(2).join(' ')
  	description = Faker::Lorem.sentence(4)
  	ProjectFile.create!(:project_id => rand(Project.count-1)+1,
  											:name => name,
  											:size => rand(10**7),
  											:extension => types[rand(types.length-1)],
  											:description => description)
	end
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
		Topic.create!(:project_id => rand(Project.count-1)+1,
									:author_id => rand(User.count-1)+1,
									:title => title)
	end
end

def make_posts
	POSTS.times do
		content = Faker::Lorem.sentences(12)
		Post.create!(:topic_id => rand(Topic.count-1)+1,
								 :author_id => rand(User.count-1)+1,
								 :content => content)
	end
end