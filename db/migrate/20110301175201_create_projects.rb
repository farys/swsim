class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.integer :owner_id
      t.integer :leader_id
      t.date :deadline
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
