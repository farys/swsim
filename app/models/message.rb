class Message < ActiveRecord::Base
  UNREAD = 2
  REPLIED = 1
  READ = 0
  DELETED = -1
  
  belongs_to :author, :class_name => "User"
  belongs_to :receiver, :class_name => "User"

  validates_length_of :topic, :maximum => 128, :allow_blank => false
  validates_length_of :body, :maximum => 500, :allow_blank => false
  validates_associated :author, :receiver
  
  named_scope :unread, lambda { {:conditions => ['status=?', Message::UNREAD]} }
  
  
#  def send
#    save
#  end
#
#  def send!
#    save!
#  end
end