# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Message do
  before(:each) do
    @message = Factory.build(:message)
  end

  it "should be valid" do
    @message.should be_valid
  end

  context "send message" do
    it "should not be valid" do
      @message.receiver = nil
      @message.receiver_login = "dsdsblabladsds"
      @message.should_not be_valid
    end

    it "should be valid when receiver login exists" do
      @user = Factory(:user)
      @message.receiver = nil
      @message.receiver_login = @user.login
      @message.should be_valid
    end

    it "should create two messages after send" do
      -> { @message.send_to_receiver}.should change(Message, :count).by(2)
    end

    it "should create two owners after send" do
      @message.topic = "message created for test event"
      @message.send_to_receiver
      @messages = Message.find_all_by_topic(@message.topic)
      @messages.size.should == 2
      @messages[0].owner.should_not == @messages[1].owner
    end
  end
  
  context "change status" do
    before do
    @message.send_to_receiver
    end

    it "should change status to replied" do
      @message.replied!
      @message.reload
      @message.status.should == Message::STATUS_REPLIED
    end

    it "should change status to deleted" do
      @message.delete!
      @message.reload
      @message.status.should == Message::STATUS_DELETED
    end

    it "should change status to read" do
      @message.read!
      @message.reload
      @message.status.should == Message::STATUS_READ
    end
  end

  context "reply message" do
    before do
      @reply_message = @message.prepare_reply_message
    end
    it "should be valid" do
      @reply_message.should be_valid
    end

    it "should have receiver login" do
      @reply_message.receiver_login.should_not be_nil
    end

    it "should not have receiver" do
      @reply_message.receiver.should be_nil
    end

  end

end

