class Tag < ActiveRecord::Base
  def self.from_text text   
    text.downcase!
    all.select {|t| not text[t.name].nil?}
  end
end
