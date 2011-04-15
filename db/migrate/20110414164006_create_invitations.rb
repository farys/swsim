class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.references :project, :null => :false
      t.references :user, :null => :false
      t.references :role, :null => :false
      t.integer :status, :null => :false

      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
