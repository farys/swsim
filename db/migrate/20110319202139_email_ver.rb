class EmailVer < ActiveRecord::Migration
  def self.up
  	create_table :emailvers do |t|
    t.string :hash, :length => 65 #:null => false zakomentowane zeby db:reload przechodzil
  	t.references :user #:null => false
  	
  	t.timestamps
  end

  def self.down
  	drop_table :emailvers
  end
  end
end
