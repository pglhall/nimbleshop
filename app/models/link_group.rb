class LinkGroup < ActiveRecord::Base

  include BuildPermalink

  has_many :navigations

  validates :name, presence: true

end
