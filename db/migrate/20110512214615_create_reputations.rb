class CreateReputations < ActiveRecord::Migration
  def self.up
    create_table :reputations do |t|
      t.integer :user_id
      t.integer :finished_auctions, :default => 0
      t.integer :auctions_overall_ratings, :default => 0
      t.integer :rated_projects, :default => 0
      t.integer :projects_overall_ratings, :default => 0
      t.integer :average_contact, :default => 0
      t.integer :average_realization, :default => 0
      t.integer :average_attitude, :default => 0
      t.integer :reputation, :default => 0

      t.timestamps
    end
    add_index :reputations, :user_id
  end

  def self.down
    drop_table :reputations
  end
end
