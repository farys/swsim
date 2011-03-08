class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.references :user, :null => false
      t.references :project, :null => false
      t.references :role, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :memberships
  end
end
