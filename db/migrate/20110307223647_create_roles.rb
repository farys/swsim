class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name, :null => false, :lenght => 30
      t.boolean  :info, :null => false, :default => false
      t.boolean  :member, :null => false, :default => false
      t.boolean  :ticket, :null => false, :default => false
      t.boolean  :file, :null => false, :default => false
      t.boolean  :forum, :null => false, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :roles
  end
end
