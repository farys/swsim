class CreateReputations < ActiveRecord::Migration
  def self.up
    create_table :reputations do |t|
      t.integer :user_id
      t.integer :value, :default => 0

      t.timestamps
    end
    add_index :reputations, :user_id
  end

  def self.down
    drop_table :reputations
  end
end
