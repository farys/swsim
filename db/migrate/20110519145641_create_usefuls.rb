class CreateUsefuls < ActiveRecord::Migration
  def self.up
    create_table :usefuls do |t|
      t.integer :blogpost_id
      t.integer :user_id

      t.timestamps
    end
    add_index :usefuls, :user_id
    add_index :usefuls, :blogpost_id
  end

  def self.down
    drop_table :usefuls
  end
end
