class LinkGroup < ActiveRecord::Base

  include BuildPermalink

  has_many :navigations

  before_create :set_permalink

end
