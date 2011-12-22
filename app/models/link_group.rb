class LinkGroup < ActiveRecord::Base

  include BuildPermalink

  has_many :navigations

end
