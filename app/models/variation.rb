class Variation < ActiveRecord::Base

  alias_attribute :label, :name

  serialize :content, Array

  belongs_to :product

  scope :active, where(active: true)
  scope :not_active, where(active: false)

  before_save :update_variants

  def content_for_select_options
    content
  end

  private

  def update_variants
    if self.active_changed? && (self.active == false)
      self.product.variants.each do |variant|
        variant.update_attribute("#{variation_type}_value", nil)
      end
    end
  end

end
