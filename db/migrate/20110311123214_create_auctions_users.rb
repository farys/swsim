class CreateAuctionsUsers < ActiveRecord::Migration
  def self.up
    create_table :auctions_users, :id => false do |t|
      t.references :auction
      t.references :user
    end
  end

  def self.down
    drop_table :auction_users
  end
end
