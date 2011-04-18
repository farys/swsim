class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.references :project, :null => :false
      t.references :user
      t.string :title, :null => :false, :length => 50
      t.text :description, :null => :false, :length => 2000
      t.integer :duration, :null => :false
      t.integer :status, :null => :false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
