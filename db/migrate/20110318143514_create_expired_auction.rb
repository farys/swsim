class CreateExpiredAuction < ActiveRecord::Migration
  def self.up
    create_table :expired_auctions, :id => false do |t|
      t.timestamp :expired_at
      t.references :auction
    end
    add_index :expired_auctions, :auction_id
    add_index :expired_auctions, :expired_at
  end

  def self.down
    drop_table :expired_auctions
  end
end
