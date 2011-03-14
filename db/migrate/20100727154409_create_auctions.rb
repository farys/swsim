class CreateAuctions < ActiveRecord::Migration
  def self.up
    create_table :auctions do |t|
      t.boolean :private, :default => FALSE, :null => false
      t.integer :status, :default => 0, :null => false
      t.integer :budget_id, :null => false
      t.references :owner, :null => false
      t.references :won_offer
      t.string :title, :length => 50, :null => false
      t.text :description, :length => 2000, :null => false
      
      t.timestamp :expired_at, :null => false
      t.integer :offers_count, :default => 0
      t.integer :visits, :default => 0, :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :auctions
  end
end
