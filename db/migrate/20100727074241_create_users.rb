class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login, :null => false, :length => 40
      t.string :name, :null => false, :length => 40
      t.string :lastname, :null => false, :length => 40
      t.string :country, :null => false, :length => 30
      t.string :email, :null => false, :length => 50
      t.string :password, :null => false
      t.integer :status,  :null => false, :default => 1
      t.string :role, :null => false, :default => "user"
      t.string :salt, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
