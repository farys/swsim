class CreateStatistics < ActiveRecord::Migration
  def self.up
    create_table :statistics do |t|
      t.string :name, :length => 32, :null => :false
      t.text :value, :null => :false

      t.timestamps
    end
  end

  def self.down
    drop_table :statistics
  end
end
