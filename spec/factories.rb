require 'factory_girl'

Factory.sequence :login do |n|
  "quake_#{n}"
end

Factory.sequence :lastname do |n|
  "Kowalski_#{n}"
end

Factory.sequence :email do |n|
  "email#{n}@sasa.pl"
end

Factory.sequence :title do |n|
  "Tytul aukcji numer #{n}"
end

Factory.sequence :tag_name do |n|
  "name #{n}"
end

Factory.define :user do |u|
  u.login {Factory.next(:login)}
  u.password "password"
  u.name "name"
  u.lastname {Factory.next(:lastname)}
  u.role 'user'
  u.status 1
  u.country "pl"
  u.email {Factory.next(:email)}
end

Factory.define :auction do |a|
a.title {Factory.next(:title)}
a.description "Za terminowe wykonanie zlecenia mozliwa premia! Dziekuje"
a.expired_after 14
a.budget_id 1+Random.rand(Budget.ids.size)
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
t.name { Factory.next(:tag_name)}
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

Factory.define :message do |m|
  m.association(:author, :factory => :user)
  m.association(:receiver, :factory => :user)
  m.body "Tresc wiadomosci testowej"
  m.topic "Wiadomosc testowa"
end