class Page < ActiveRecord::Base

  include BuildPermalink

  before_create :set_permalink

  def url
    "/pages/#{self.permalink}"
  end

end
