class Product < ActiveRecord::Base

  alias_attribute :title, :name

  include BuildPermalink

  validates :status, inclusion: { :in => %w(active hidden sold_out) }, presence: true

  has_many :variations, order: "variation_type asc"

  has_many :variants
  accepts_nested_attributes_for :variants, allow_destroy: true

  has_many :pictures
  accepts_nested_attributes_for :pictures, allow_destroy: true

  has_many :custom_field_answers do
    def for(custom_field_name)
      # TODO this one is causing one extra query. Look into removing it
      custom_field = CustomField.find_by_name(custom_field_name)
      where(['custom_field_answers.custom_field_id = ?', custom_field.id]).limit(1).try(:first)
    end
  end
  accepts_nested_attributes_for :custom_field_answers, allow_destroy: true

  scope :with_prictures, includes: 'pictures'

  validates_presence_of :name, :description, :price
  validates_numericality_of :price

  after_create :create_variation_records

  def variation1
    self.variations.find_by_variation_type('variation1')
  end
  def variation2
    self.variations.find_by_variation_type('variation2')
  end
  def variation3
    self.variations.find_by_variation_type('variation3')
  end

  def update_variation_names(params)
    %w(variation1 variation2 variation3).each do |v|
      key = "#{v}_value".intern
      if params[key].present?
        self.variations.find_by_variation_type(v).update_attributes(name: params[key])
      end
    end
  end

  def picture
    pictures.first
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
    self.variations.create!(variation_type: 'variation1', name: 'Color')
    self.variations.create!(variation_type: 'variation2', name: 'Size')
    self.variations.create!(variation_type: 'variation3', name: 'Material')
  end

  def variant_price_data
    temp = variants.map do |v|
      k = [v.variation1_parameterized, v.variation2_parameterized, v.variation3_parameterized].compact.join('')
      [k, v.price.round(2).to_f]
    end.flatten
    Hash[*temp]
  end

end
