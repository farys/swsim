# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Budget do

  it "should return array of ids" do
    @ids = Budget.ids
    assert_equal(@ids.class, Array)
    @ids.each do |b|
      assert_equal(b.class, Fixnum)
    end
  end
  
  it "should return array of BudgetRecord" do
    @all = Budget.all
    assert_equal(@all.class, Array)
    @all.each do |b|
      assert_equal(b.class, BudgetRecord)
    end
  end

  it "should return BudgetRecord" do
    @b = Budget.find(1)
    assert_equal(@b.class, BudgetRecord)
  end

  it "should return array of BudgetRecord" do
    ->{ Budget.find(0)}.should raise_error
  end
end

