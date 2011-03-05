class CreateAuctionsRatings < ActiveRecord::Migration
  def self.up
  	create_table :auction_ratings, :id => false do |t|
  		t.references :user, :null => false
  		t.references :auction, :null => false
  		t.float :value, :null => false
  		t.timestamp :created_at
  	end
    add_index :auction_ratings, [:user_id, :auction_id]
    
  	add_column :auctions, :rating, :float, :default => 0
    add_index :auctions, :rating
  end

  def self.down
    remove_index :auctions, :rating
  	remove_column :auctions, :rating

  	remove_index :auction_ratings, [:user_id, :auction_id]
  	drop_table :auction_ratings
  end
end
