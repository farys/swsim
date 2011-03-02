class Tag < ActiveRecord::Base
  belongs_to :group

  def self.from_text text   
    text.downcase!
    all.select {|t| not text[t.name].nil?}
  end

  def to_s
    self.name
  end
end
