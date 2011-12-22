class Page < ActiveRecord::Base

  include BuildPermalink

  def url
    "/pages/#{self.permalink}"
  end

end
