require 'factory_girl'
require 'faker'
I18n.locale = :en

Factory.sequence :login do |n|
  "quake_#{n}"
end

Factory.sequence :lastname do |n|
  "Kowalski_#{n}"
end

Factory.sequence :name do |n|
  "name #{n}"
end

Factory.sequence :email do |n|
  Faker::Internet.email
end

Factory.sequence :title do |n|
  "Tytul aukcji numer #{n}"
end

Factory.define :user do |u|
  firstname = Faker::Name.first_name
  country = Carmen.default_country
  u.login {Factory.next(:login)}
  u.password "password"
  u.name firstname
  u.lastname {Factory.next(:lastname)}
  u.role 'user'
  u.status 1
  u.country country
  u.email {Factory.next(:email)}
end

Factory.define :auction do |a|
a.title {Factory.next(:title)}
a.description "Za terminowe wykonanie zlecenia mozliwa premia! Dziekuje"
a.expired_after 14
a.budget_id 1+rand(Budget.ids.size)
a.association(:owner, :factory => :user)
end

Factory.define :offer do |o|
o.price 1+rand(500)
o.days 1+rand(30)
o.association(:offerer, :factory => :user)
o.association(:auction)
end

Factory.define :communication do |c|
c.association(:auction)
c.body "opis opis opis opis opis opis opis opis opis opis opis opis opis opis opis"
end

Factory.define :group do |g|
g.name "grupa"
end

Factory.define :tag do |t|
t.name { Factory.next(:name)}
t.association(:group)
end

Factory.define :auction_invitation do |i|
i.association(:auction)
i.association(:user)
end

Factory.define :auction_rating do |r|
r.association(:auction)
r.association(:user)
r.value 1+rand(4)
end
