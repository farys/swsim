class Comment < ActiveRecord::Base
  STATUSES = {:active => 0, :pending => 1, :deleted => 2}
  LEVELS = {:auction => 0, :project => 1}

  attr_accessor :allowed_points
  
  belongs_to :author, :class_name => "User"
  belongs_to :receiver, :class_name => "User"
  belongs_to :auction
  belongs_to :project
  has_many :values, :class_name => "CommentValue", :dependent => :destroy, :include => [:keyword]

  validates :values, :associated => true

  scope :pending, ->{ where(:status => STATUSES[:pending])}
  scope :active, ->{ where(:status => STATUSES[:active])}
  default_scope includes(:values)

  before_save :default_attributes
  before_validation :check_points

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

  def self.create_from_project_for_owner(project)
    self.create(
      :project => project,
      :author_id => project.leader_id,
      :receiver_id => project.owner_id,
      :level => LEVELS[:project]
    )
    self.create(
      :project => project,
      :author_id => project.owner_id,
      :receiver_id => project.leader_id,
      :level => LEVELS[:project]
    )
  end

  def self.create_from_owner_comment(comment)
    project = comment.project

    users = project.user_ids - [project.leader_id, project.owner_id]
    users.each do |user_id|
      author_id = project.leader_id
      receiver_id = user_id
      2.times do
        self.create(
          :project => project,
          :author_id => author_id,
          :receiver_id => receiver_id,
          :level => LEVELS[:project]
        )
        author_id, receiver_id = receiver_id, author_id
      end
    end
  end

  def points_mode?
    self.level?(:project) && ![self.author_id, self.receiver_id].include?(self.project.owner_id)
  end

  def owner_comment?
    !self.project.nil? && self.project.owner_id == self.author_id
  end

  def activate!
    self.status = STATUSES[:active]
    self.save
  end

  def delete!
    self.status = STATUSES[:deleted]
    self.save
  end

  def status? status
    self.status == STATUSES[status]
  end

  def level? level
    self.level == LEVELS[level]
  end

  private
  def default_attributes
    self.status = STATUSES[:pending] if self.status.nil?
  end

  def check_points
    #unless self.allowed_points.nil? && (self.allowed_points >= self.values.sum(:rating))
    # self.values.each do |v| v.errors.add(:rating, "Przekroczono dozwolona ilosc punktow") end
    #end
  end
end
