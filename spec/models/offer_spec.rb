# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Offer do
  before(:each) do
    @offer = Factory(:offer)
  end

  it "should be valid" do
    @offer.should be_valid
  end

  it "should change status after reject" do
    @offer.reject!
    @offer.reload
    @offer.status.should == Offer::STATUSES[:rejected]
  end

  it "should change status after recovery" do
    @offer.reject!
    @offer.recovery!
    @offer.reload
    @offer.status.should == Offer::STATUSES[:active]
  end

  it "should be active after create" do
    @offer.status.should == Offer::STATUSES[:active]
  end

end

