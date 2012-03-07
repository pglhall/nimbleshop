class Product < ActiveRecord::Base

  include BuildPermalink

  alias_attribute :title, :name

  validates :status, inclusion: { :in => %w(active hidden sold_out) }, presence: true

  has_many :variations, dependent: :destroy, order: "variation_type asc"
  has_many :variants, dependent: :destroy

  has_many :pictures

  has_many :custom_field_answers, dependent: :destroy do
    def for(custom_field_name)
      # TODO this one is causing one extra query. Look into removing it
      custom_field = CustomField.find_by_name(custom_field_name)
      where(['custom_field_answers.custom_field_id = ?', custom_field.id]).limit(1).try(:first)
    end
  end

  accepts_nested_attributes_for :variants, allow_destroy: true

  accepts_nested_attributes_for :pictures, allow_destroy: true

  accepts_nested_attributes_for :custom_field_answers, allow_destroy: true

  after_initialize :initialize_status

  scope :with_prictures, includes: 'pictures'

  scope :active,    where(status: 'active') 
  scope :hidden,    where(status: 'hidden') 
  scope :sold_out,  where(status: 'sold_out') 


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

  # Input is full path to the picture.
  #
  # Rails.root.join('db', 'original_pictures', filename )
  #
  def attach_picture(filename, path)
    img = File.open(path) {|i| i.read}
    encoded_img = Base64.encode64 img
    io = FilelessIO.new(Base64.decode64(encoded_img))
    io.original_filename = filename
    p = Picture.new(product: self, picture: io)
    p.save
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

  def initialize_status
    self.status ||= 'active'
  end
end
