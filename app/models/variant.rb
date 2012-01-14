class Variant < ActiveRecord::Base
  belongs_to :product

  before_save :set_parameterized_value
  after_save  :update_variation_content
  after_destroy :update_variation_content

  private

  def set_parameterized_value
    self.variation1_parameterized = variation1_value && variation1_value.parameterize
    self.variation2_parameterized = variation2_value && variation2_value.parameterize
    self.variation3_parameterized = variation3_value && variation3_value.parameterize
  end

  def update_variation_content
    %w(variation1 variation2 variation3).each do |e|
      if variation = product.variations.find_by_variation_type(e)
        a = product.variants.map { |i| i.send("#{e}_value") }.compact.uniq
        b = a.map { |e| [e, e.parameterize] }
        variation.update_attributes!(content: b)
      end
    end
  end

end
