# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Users
farysUser = User.create(:login => "farys", :password => 'farys')
stefanUser = User.create(:login => 'stefan', :password => 'stefan')
User.create(:login => 'quake', :password => 'quake')
User.create(:login => 'abraham', :password => 'abraham')

aukcja = Auction.create!(
  :owner => farysUser,
  :title => "Wyszukiwarka google na forum",
  :description => "Zlece wykonanie wyszukiwarki google w oparciu o zasoby forum. Za terminowe wykonanie zlecenia mozliwa premia! Dziekuje",
  :expired_after => 14.to_s,
  :budget_id => "1"
)
aukcja2 = Auction.create!(
  :owner => stefanUser,
  :title => "Zaindeksowanie do wyszukiwarek",
  :description => "Jestem laikiem w kwestiach informatycznych, wiec chcialbym zlecic wdrozenie mojej strony do najpopularniejszych wyszukiwarek. Wiem iz wyszukiwarka Google jest najpopularniejsza, wiec najbardziej mi zalezy na niej.",
  :expired_after => 14.to_s,
  :budget_id => "2"
)
aukcja3 = Auction.create!(
  :owner => stefanUser,
  :title => "Prosta wyszukiwarka na stronie",
  :description => "Prosta wyszukiwarka na strone", 
  :expired_after => 10.to_s,
  :budget_id => "1"
)
