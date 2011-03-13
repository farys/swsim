class CreateAuctionInvitations < ActiveRecord::Migration
  def self.up
    create_table :auction_invitations, :id => false do |t|
      t.references :auction
      t.references :user
    end
  end

  def self.down
    drop_table :auction_invitations
  end
end
