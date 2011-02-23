class Message < ActiveRecord::Base
  STATUS_UNREAD = 2
  STATUS_REPLIED = 1
  STATUS_READ = 0
  STATUS_DELETED = -1
  
  belongs_to :owner, :class_name => "User", :include => true
  belongs_to :author, :class_name => "User", :include => true
  belongs_to :receiver, :class_name => "User", :include => true

  validates_length_of :topic, :maximum => 128, :minimum => 10, :allow_blank => false
  validates_length_of :body, :maximum => 500, :minimum => 10, :allow_blank => false  
  validates_associated :author, :receiver, :owner
  
  scope :sent, lambda { where('author_id=owner_id')}
  scope :received, lambda { where('receiver_id=owner_id')}
  
  scope :with_status, lambda {|sts| where('status>=?', sts)}
  
  def send_to_receiver
    return false unless self.save

    new_msg = Message.new self.attributes
    new_msg.owner_id = self.receiver_id
    new_msg.id = nil
    new_msg.save
  end
  
  def prepare_reply_text!(reply_msg)
    self.topic = 'Re: '+reply_msg.topic
    self.body = '<br /><br />'+reply_msg.author.to_s+' napisal: <br />'+reply_msg.body
  end
end