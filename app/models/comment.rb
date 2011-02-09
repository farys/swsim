class Comment < ActiveRecord::Base
  belongs_to :auction
  belongs_to :author, :class_name => "User"
  belongs_to :receiver, :class_name => "User"
  belongs_to :team
  has_many :values, :class_name => "CommentValue", :dependent => :destroy

  validates_numericality_of :mark, :allow_blank => :true
  validates_numericality_of :status, :allow_blank => :true #jesli puste to domyslnie otrzymuje w bazie status waiting
  validates_associated :auction, :author, :receiver
end
