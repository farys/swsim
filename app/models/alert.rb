#encoding: utf-8
class Alert < ActiveRecord::Base
  belongs_to :author, :class_name => "User"
  belongs_to :reader, :class_name => "User"
  belongs_to :model, :polymorphic => true

  validates :text, :presence => true
  validates_associated :author, :reader
  
  def offer_to_reject_text! user, text
    self.text = "Użytkownik #{user.to_s} prosi o odrzucenie jego oferty, wytłumaczenie:<br /> #{text}" 
  end
end
