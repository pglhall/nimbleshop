class LinkGroup < ActiveRecord::Base

  include Permalink::Builder

  has_many :navigations, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
