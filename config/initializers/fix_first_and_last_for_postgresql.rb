# FIXME
class ActiveRecord::Base

  def self.first
    self.order('id asc').first
  end

  def self.last
    self.order('id desc').first
  end

end
