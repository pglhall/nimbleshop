class LinkGroup < ActiveRecord::Base

  include BuildPermalink

  has_many :navigations

  #only words, more than two letters
  validates :name, format: { with: /\b\w{2,}\b/ }

end
