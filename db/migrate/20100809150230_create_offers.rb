class CreateOffers < ActiveRecord::Migration
  def self.up
    create_table :offers do |t|
      t.references :auction, :null => false
      t.references :offerer, :null => false
      t.integer :status, :null => false
      t.decimal :price, :null => false
      t.integer :hours, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :offers
  end
end
