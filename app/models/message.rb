class Message < ActiveRecord::Base
  STATUS_UNREAD = 2
  STATUS_REPLIED = 1
  STATUS_READ = 0
  STATUS_DELETED = -1

  attr_accessor :receiver_login
  validates :receiver_login, :presence => true, :on => :create
  before_validation :check_receiver_login, :on => :create

  belongs_to :owner, :class_name => "User", :include => true
  belongs_to :author, :class_name => "User", :include => true
  belongs_to :receiver, :class_name => "User", :include => true

  validates_length_of :topic, :maximum => 128, :minimum => 10, :allow_blank => false
  validates_length_of :body, :maximum => 500, :minimum => 10, :allow_blank => false  

  default_scope where('status>='+STATUS_READ.to_s)
  scope :sent, lambda { where('author_id=owner_id')}
  scope :received, lambda { where('receiver_id=owner_id')}
  scope :with_status, lambda {|sts| where(:status => sts)}

  def check_receiver_login
    return if (not self.receiver_id.nil?) || self.receiver_login.empty?
    user = User.find_by_login(self.receiver_login)
    if user.nil?
      self.errors.add("receiver_login", "dont exists")
      return
    end
    self.receiver = user
  end

  def replied!
    self.update_attribute(:status, STATUS_REPLIED)
  end
  
  def read!
    self.update_attribute(:status, STATUS_READ)
  end
  
  def delete!
    self.update_attribute(:status, STATUS_DELETED)
  end

  def send_to_receiver
    return false unless self.save

    new_msg = Message.new self.attributes
    new_msg.receiver_login = self.receiver.login
    new_msg.owner_id = self.receiver_id
    new_msg.save
  end
  
  def prepare_reply_message
    msg = Message.new
    msg.receiver_login = self.author.login
    msg.topic = 'Re: '+self.topic
    msg.body = '<br /><br />'+self.author.to_s+' napisal: <br />'+self.body
    msg
  end
end