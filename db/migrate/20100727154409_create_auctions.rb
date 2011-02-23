class CreateAuctions < ActiveRecord::Migration
  def self.up
    create_table :auctions do |t|
      t.references :category, :null => false
      t.boolean :private, :default => 0, :null => false
      t.integer :status, :default => 0, :null => false
      t.integer :budget_id, :null => false
      t.references :owner, :null => false
      t.references :won_offer
      t.string :title, :null => false
      t.text :description, :length => 5000, :null => false #ograniczenie 5000
      
      t.timestamp :expired, :null => false
      t.integer :offers_count, :default => 0
      t.integer :visits, :default => 0, :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :auctions
  end
end
