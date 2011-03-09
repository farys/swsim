class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name, :length => 32, :null => false
      t.integer :status, :null => false
    end
  end

  def self.down
    drop_table :groups
  end
end
