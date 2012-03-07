class LinkGroup < ActiveRecord::Base

  include BuildPermalink

  has_many :navigations, dependent: :destroy

  validates :name, presence: true
end
