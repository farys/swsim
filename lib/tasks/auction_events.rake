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

    Auction.where(:id => auction_ids).where(:status => Auction::STATUSES[:active]).each { |a|
      if a.offers.empty?
        a.finish!
        Sender.auction_finished(a).deliver
      else
        a.waiting_for_offer!
        Sender.auction_waiting_for_offer(a).deliver
      end
      a.save
    }
    ExpiredAuction.where(:auction_id => auction_ids).delete_all
    puts "\nExpired auctions: #{auction_ids.size}\n"
  end

  desc "Checks for auctions with status 'waiting_for_offer'"
  task :offers => :environment do
    auctions = Auction.
      where("(expired_at + INTERVAL 1 DAY) < ?", Time.now.to_s).
      where(:status => Auction::STATUSES[:waiting_for_offer]).
      all.each do |a|
      a.canceled!
      Sender.auction_canceled(a).deliver
    end
  end
end
