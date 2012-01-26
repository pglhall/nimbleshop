class LinkGroup < ActiveRecord::Base

  include BuildPermalink

  has_many :navigations

  validates :name, format: { with: /\b\w{2,}\b/ }

end
