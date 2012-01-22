class Variant < ActiveRecord::Base

  belongs_to :product

  validates_presence_of :price
  validates_numericality_of :price, greater_than: 0, :if => lambda {|record| record.price.present?}

  validate :all_active_variations_not_empty
  validate :ensure_no_duplicate_records

  before_save :set_parameterized_value, :all_non_active_variations_should_be_nil
  after_save  :update_variation_content
  after_destroy :update_variation_content

  def info
    [variation1_value, variation2_value, variation3_value].compact.to_sentence
  end

  def self.record_for_given_variations(variation1_value, variation2_value, variation3_value)
    return nil if variation1_value.blank? && variation2_value.blank? && variation3_value.blank?
    scoped = Variant.scoped
    scoped = scoped.where(variation1_parameterized: variation1_value) if variation1_value.present?
    scoped = scoped.where(variation2_parameterized: variation2_value) if variation2_value.present?
    scoped = scoped.where(variation3_parameterized: variation3_value) if variation3_value.present?
    scoped.to_a.first
  end

  private

  def all_non_active_variations_should_be_nil
    product.variations.not_active.each do |variation|
      type = variation.variation_type
      self.send("#{type}_value=", nil)
    end
  end

  def ensure_no_duplicate_records
    return if self.errors.any?
    v = Variant.scoped
    v = v.where(variation1_value: self.variation1_value) if product.variation1.active
    v = v.where(variation2_value: self.variation2_value) if product.variation2.active
    v = v.where(variation3_value: self.variation3_value) if product.variation3.active
    v = v.where("id != #{self.id}") if self.persisted?
    count = v.count
    if count > 0
      msg = []
      msg << self.variation1_value if product.variation1.active
      msg << self.variation2_value if product.variation2.active
      msg << self.variation3_value if product.variation3.active
      msg.compact!
      self.errors.add(:base, "Already a record exists for combination #{msg.to_sentence}")
    end
  end

  def all_active_variations_not_empty
    self.product.variations.active.each do |variation|
      type = variation.variation_type
      if self.send("#{type}_value").blank?
        self.errors.add(:base, "#{variation.name} should not be empty")
      end
    end
  end

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
