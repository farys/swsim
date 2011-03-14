class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name, :null => false, :lenght => 50
      t.integer :owner_id, :null => false
      t.integer :leader_id, :null => false
      t.integer :duration, :null => false
      t.integer :status, :null => false
      t.text :description, :null => false, :lenght => 2000

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
