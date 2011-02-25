# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

#TODO przeniest tworzenie testowych danych do pliku /lib/tasks/sample_data.rake !

# Users

  farysUser = User.create(:login => "farys", :password => 'farys')
  stefanUser = User.create(:login => 'stefan', :password => 'stefan')
  User.create(:login => 'quake', :password => 'quake')
  User.create(:login => 'abraham', :password => 'abraham')
  Tag.create([
    {:name => "zaawansowane"},
    {:name => "portal web 2.0"},
    {:name => "pozycjonowanie"},
  ])
  googleTag = Tag.create(:name => "google")
  easyTag = Tag.create(:name => "proste")
  
  programowanie = Category.create(:name => "Programowanie")
  grafika = Category.create(:name => "Grafika")
  reklama = Category.create(:name => "Reklama")
  
  Category.create(:name => "C++", :parent => programowanie)
  Category.create(:name => "PHP", :parent => programowanie)
  ruby = Category.create(:name => "Ruby", :parent => programowanie)

  Category.create([{:name => "Szablony www", :parent => grafika},
    {:name => "Loga na www", :parent => grafika},
    {:name => "Wizytowki", :parent => grafika},
    {:name => "Plakaty", :parent => grafika},
    {:name => "Na aukcje", :parent => grafika},

    {:name => "Na www", :parent => reklama},
    {:name => "Pozycjonowanie", :parent => reklama}
  ])
  
  reklama_pozycjonowanie = Category.find_by_name("Pozycjonowanie")
  
  aukcja = Auction.create( :owner => farysUser, :title => "Wyszukiwarka google na forum", :description => "Zlece wykonanie wyszukiwarki google w oparciu o zasoby forum. Za terminowe wykonanie zlecenia mozliwa premia! Dziekuje", :category => ruby, :expired_after => 14.to_s)
  aukcja2 = Auction.create( :owner => stefanUser, :title => "Zaindeksowanie do wyszukiwarek", :description => "Jestem laikiem w kwestiach informatycznych, wiec chcialbym zlecic wdrozenie mojej strony do najpopularniejszych wyszukiwarek. Wiem iz wyszukiwarka Google jest najpopularniejsza, wiec najbardziej mi zalezy na niej.", :category => reklama_pozycjonowanie, :expired_after => 14.to_s)
  aukcja3 = Auction.create( :owner => stefanUser, :title => "Prosta wyszukiwarka na stronie", :description => "Prosta wyszukiwarka na strone", :category => ruby, :expired_after => 10.to_s)

  aukcja2.tags << googleTag
  aukcja3.tags << googleTag
  aukcja3.tags << easyTag
  