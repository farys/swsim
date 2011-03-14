# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Group do
  before(:each) do
    @group = Factory(:group)
    @hidden_group = Factory(:group, :status => Group::STATUSES[:hidden])
  end

  it "should be valid" do
    @group.should be_valid
  end

  it "should return good title" do
    @group.to_s.should eq(@group.name)
  end

  it "should be active by default" do
    @group.status.should == Group::STATUSES[:active]
  end

  context "array to select input" do
    it "should return only active groups" do
      group_ids = Group.array_to_select.map{|row| row[1]}
        Group.where(:status => :active, :id => group_ids).count.should == group_ids.size
    end

    it "should return all groups" do
      Group.all.count.should == Group.admin_array_to_select.size
    end
  end

end

