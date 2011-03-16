class Comment < ActiveRecord::Base
  STATUSES = {:active => 0, :pending => 1, :deleted => 2}
  LEVELS = {:auction => 0, :project => 1, :team => 2, :leader => 3}
  
  belongs_to :author, :class_name => "User"
  belongs_to :receiver, :class_name => "User"
  belongs_to :auction
  belongs_to :project
  has_many :values, :class_name => "CommentValue", :dependent => :destroy

  scope :pending, ->{ where(:status => STATUSES[:pending])}
  
  before_save :default_attributes

  def self.create_from_auction(auction)
    owner = auction.owner
    offerer = auction.won_offer.offerer

    2.times do
      self.create(
        :auction => auction,
        :author => owner,
        :receiver => offerer,
        :level => LEVELS[:auction]
      )
      owner, offerer = offerer, owner
    end
  end

  private
  def default_attributes
    self.status = STATUSES[:pending] if self.status.nil?
  end
end
