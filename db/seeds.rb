#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Users
admin =  User.create!(
  :login => "admin",
  :password => 'password',
  :name => "Jan",
  :lastname => "Kowalski",
  :country => "pl",
  :email => "admin@example.com",
  :description => "Witam. Jestem administratorem w naszym portalu. Z wszelkimi problemami zgłaszaj się do mnie :)"
)
admin.status = 2
admin.role = "administrator"
admin.save

CommentKeyword.create!(
  [{ :name => "Kontakt" },
    { :name => "Realizacja" },
    { :name => "Stosunek do użytkownika" }
  ])

Budget.create([
    {:title => "< 500 zł"},
    {:title => "500 - 1000 zł"},
    {:title => "1000 - 2500 zł"},
    {:title => "2500 - 5000 zł"},
    {:title => "> 5000 zł"}
  ])
  
Role.create!(:name => 'guest')
Role.create!(:name => 'leader', :file => true, 
                                :forum => true,
                                :member => true,
                                :info => true,
                                :ticket => true)
Role.create!(:name => 'owner', :info => true)
Role.create!(:name => 'info_mod', :info => true)
Role.create!(:name => 'member_mod', :member => true)
Role.create!(:name => 'ticket_mod', :ticket => true)
Role.create!(:name => 'file_mod', :file => true)
Role.create!(:name => 'forum_mod', :forum => true)
