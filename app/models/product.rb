class Product < ActiveRecord::Base

  alias_attribute :title, :name

  include BuildPermalink

  has_many :variations
  has_many :variants
  has_many :pictures

  has_many :custom_field_answers do
    def for(custom_field_name)
      # TODO this one is causing one extra query. Look into removing it
      custom_field = CustomField.find_by_name(custom_field_name)
      where(['custom_field_answers.custom_field_id = ?', custom_field.id]).limit(1).try(:first)
    end
  end

  accepts_nested_attributes_for :pictures, allow_destroy: true
  accepts_nested_attributes_for :custom_field_answers, allow_destroy: true

  scope :with_prictures, includes: 'pictures'

  validates_presence_of :name, :description, :price
  validates_numericality_of :price

  after_create :create_variation_records

  def picture
    pictures.first
  end

  # TODO this method should not exist. All such custom fields should be generated dynamically
  def category
    custom_field_value_for('category')
  end

  def custom_field_value_for(custom_field_name)
    self.custom_field_answers.for(custom_field_name).value
  end

  def find_or_build_answer_for_field(field)
    self.custom_field_answers.detect {|t| t.custom_field_id.to_s == field.id.to_s } ||
      self.custom_field_answers.build(custom_field_id: field.id)
  end

  def find_or_build_all_answers
    CustomField.all.each { |f| find_or_build_answer_for_field(f) }
  end

  def create_variation_records
    self.variations.create!(variation_type: 'variation1')
    self.variations.create!(variation_type: 'variation2')
    self.variations.create!(variation_type: 'variation3')
  end

  def variant_price_data
    temp = variants.map do |v|
      k = [v.variation1_parameterized, v.variation2_parameterized, v.variation3_parameterized].compact.join('')
      [k, v.price.round(2).to_f]
    end.flatten
    Hash[*temp]
  end


end
