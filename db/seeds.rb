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