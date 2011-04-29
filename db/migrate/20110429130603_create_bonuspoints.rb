class CreateBonuspoints < ActiveRecord::Migration
  def self.up
    create_table :bonuspoints do |t|
      t.integer :points, :default => 20
      t.integer :user_id, :default => 1
      t.integer :for_what, :default => 1 #1 - bought, 2 - for blogpost, 3 - for reference user

      t.timestamps
    end
    add_index :bonuspoints, :user_id
  end

  def self.down
    drop_table :bonuspoints
  end
end
