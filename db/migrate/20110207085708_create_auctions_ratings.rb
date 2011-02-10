class CreateAuctionsRatings < ActiveRecord::Migration
  def self.up
  	create_table :auction_ratings, :id => false do |t|
  		t.references :user, :null => false
  		t.references :auction, :null => false
  		t.float :value, :null => false
  		t.timestamp :created_at
  	end
  	add_index :auction_ratings, [:user_id, :auction_id], :unique => true

  	add_column :auctions, :ratings_sum, :integer, :default => 0
  	add_column :auctions, :ratings_count, :integer, :default => 0
  end

  def self.down
  	remove_column :auctions, :ratings_sum
  	remove_column :auctions, :ratings_count
  	remove_index :auction_ratings, [:user_id, :auction_id]

  	drop_table :auction_ratings
  end
end
