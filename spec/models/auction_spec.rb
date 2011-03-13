# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Auction do
  before(:each) do
    @auction = Factory(:auction)
    @auction_owner = @auction.owner
    @auction_offer = Factory(:offer, :auction => @auction)
    @offer = Factory(:offer)
    @user = Factory(:user)
    @tag = Factory(:tag)
  end

  it "should be valid" do
    @auction.should be_valid
  end
  
  context "methods" do
    it "should to_s return a good title" do
      @auction.to_s.should eq(@auction.title)
    end

    it "should change status to canceled" do
      @auction.cancel!
      @auction.reload
      @auction.status.should == Auction::STATUSES[:canceled]
    end
    
    it "should won_offer_exists? return false" do
      @auction.won_offer.should be_nil
      @auction.won_offer_exists?.should be_false
    end

    it "should be public auction by default" do
      @auction.public?.should be_true
    end

    it "should be active after create" do
      @auction.status.should == Auction::STATUSES[:active]
    end

    it "should recognize a auction owner" do
      @auction.owner?(@auction_owner).should be_true
      @auction.owner?(@user).should_not be_true
    end
  end

  context "invitation" do
    it "should allow user to see auction when private" do
      @auction.private = true
      @auction.invitations << Factory(:auction_invitation, :auction => @auction, :user => @user)
      @auction.allowed_to_see?(@user).should be_true
    end
    
    it "should not allow user to see auction when private" do
      @auction.private = true
      @auction.allowed_to_see?(@user).should be_false
    end

    it "should return true if user invited" do
      @auction.private = true
      @auction.invitations << Factory(:auction_invitation, :auction => @auction, :user => @user)
      @auction.invited?(@user).should be_true
    end

    it "should return false if user not invited" do
      @auction.private = true
      @auction.invited?(@user).should be_false
    end
  end

  context "offers" do
    it "should allow another user to offer when public" do
      @auction.allowed_to_offer?(@user).should be_true
    end
    
    it "should not allow to create a offer again" do
      @auction.offers << Factory(:offer, :offerer => @user, :auction => @auction)
      @auction.allowed_to_offer?(@user).should be_false
    end
    
    it "should not allow to create a offer when auction is private and user not invited" do
      @auction.private = true
      @auction.invitations.clear
      @auction.allowed_to_offer?(@user).should be_false
    end

    it "should return true if user dont made offer before" do
      @auction.allowed_to_offer?(@user).should be_true
    end

    it "should return false if user made offer before" do
      @auction.offers << Factory(:offer, :auction => @auction, :offerer => @user)
      @auction.allowed_to_offer?(@user).should be_false
    end

    it "should not allow owner to create a offer" do
      @auction.allowed_to_offer?(@auction_owner).should be_false
    end

    it "should return true if user made offer" do
      -> { @auction.offers << Factory(:offer, :offerer => @user, :auction => @auction)}.should change(Offer, :count)
      @auction.made_offer?(@auction_offer.offerer).should be_true
    end

    it "should return false if user dont made offer" do
      @auction.made_offer?(@user).should be_false
    end

  end

  context "access" do

    it "should allow guest to see auction when public" do
      @auction.allowed_to_see?(nil).should be_true
    end

    it "should not allow guest to see auction when private" do
      @auction.private = true
      @auction.allowed_to_see?(nil).should_not be_true
    end

    it "should allow all users and owner to see auction when public" do
      @auction.allowed_to_see?(@user).should be_true
      @auction.allowed_to_see?(@auction_owner).should be_true
    end

    it "should allow owner to see auction when private" do
      @auction.private = true
      @auction.allowed_to_see?(@auction_owner).should be_true
    end
  end

  context "on choosing a won_offer" do
    it "should set offer as a won offer" do
      @auction.set_won_offer!(@auction_offer).should be_true
      @auction.reload
      @auction_offer.reload

      @auction.won_offer.should == @auction_offer
      @auction_offer.status.should == Offer::STATUSES[:won]
      @offer.status.should_not == Offer::STATUSES[:won]
    end
    
    it "should not accept a offer from another auction" do
      @auction.set_won_offer!(@offer).should be_false
      @auction.status.should_not == Auction::STATUSES[:finished]
    end

    it "should change status after choosed won offer" do
      @auction.set_won_offer!(@auction_offer)
      @auction.status.should == Auction::STATUSES[:finished]
    end
  end

  context "rating" do
    it "should allow user to rating" do
      @auction.allowed_to_rate?(@user).should be_true
    end

    it "should dont allow user to rate again" do
      @auction.rate(@user, 5)
      @auction.allowed_to_rate?(@user).should be_false
    end

    it "should return true if user rated" do
      @auction.rate(@user, 5)
      @auction.rated_by?(@user).should be_true
    end

    it "should return false if user dont rate before" do
      @auction.rate(Factory(:user), 5)
      @auction.rated_by?(@user).should be_false
    end
    
    it "should create a rate value" do
      ->{ @auction.rate(@user, 5) }.should change(AuctionRating, :count).by(1)
    end

    it "should return rating value" do
      @auction.rate(@user, 5)
      @auction.rating.should == 5
    end
  end

  context "on destroy" do
    it "should delete all ratings values" do
      Factory(:auction).rate(Factory(:user), 5)
      @auction.rate(@user, 5)
      @auction.rate(Factory(:user), 5)
      ->{ @auction.destroy}.should change(AuctionRating, :count).by(-2)
    end

    it "should delete all offers" do
      Factory(:offer)
      -> { @auction.destroy}.should change(Offer, :count).by(-1)
    end

    it "should delete all communications" do
      Factory(:communication)
      Factory(:communication, :auction => @auction)
      -> { @auction.destroy}.should change(Communication, :count).by(-1)
    end

    it "should delete all tags links" do
      3.times {Factory(:tag)}
      @auction.tags << [@tag, Factory(:tag)]
      @auction.destroy
      @tag.auctions.should be_empty
    end
  end
end
