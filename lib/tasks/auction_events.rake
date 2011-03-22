namespace :auction do

  desc "Fill table with finishing auctions"
  task :update => :environment do
    Rake::Task["auction:finish"].invoke
    auctions = Auction.
      where("expired_at < ?", (Time.now + 1.hour).to_s).
      where(:status => Auction::STATUSES[:active]).
      all
    hash = auctions.map {|a| {:auction_id => a.id, :expired_at => a.expired_at}}
    ExpiredAuction.delete_all
    ExpiredAuction.create(hash)
  end

  desc "Finish expired auctions"
  task :finish => :environment do
    expired = ExpiredAuction.where("expired_at < ?", Time.now.to_s).all
    auction_ids = expired.map{|a| a.auction_id}

    Auction.where(:id => auction_ids).each { |a|
      a.status = Auction::STATUSES[:finished]
      a.save
    }
    ExpiredAuction.where(:auction_id => auction_ids).delete_all
    puts "\nExpired auctions: #{auction_ids.size}\n"
  end
end
