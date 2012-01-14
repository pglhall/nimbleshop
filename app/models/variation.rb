class Variation < ActiveRecord::Base

  alias_attribute :label, :name

  serialize :content, Array

  belongs_to :product

  scope :active, where("name is NOT null")

  def content_for_select_options
    content
  end

end
