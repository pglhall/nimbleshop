class Variation < ActiveRecord::Base

  alias_attribute :label, :name

  serialize :content, Array

  belongs_to :product

  scope :active, where(active: true)
  scope :not_active, where(active: false)

  def content_for_select_options
    content
  end

end
