class ProductGroup < ActiveRecord::Base

  attr_accessor :custom_field_id, :custom_field_operator, :custom_field_value

  include BuildPermalink

  serialize :condition

  validates :name, presence: true
  validates :custom_field_id, presence: true, :if => lambda { |record| record.condition.blank? }

  before_create :set_permalink

  # determines if the given product exists in the product group
  def exists?(product)
    products.include?(product)
  end

  def to_param
    self.permalink
  end

  def products
    Product.search(condition)
  end

  def custom_field_object
    CustomField.find(condition.keys.first.gsub(/q/,''))
  end

  # list of all product groups containing input product
  def self.contains_product(product)
    self.all.select do |pg|
      pg.exists?(product)
    end
  end

  def condition_in_english
    value = condition.values.first
    output = if Array === value
      value.map { |v| _process_cie(v) }.join(' and ')
    else
      _process_cie(value)
    end
    output.capitalize
  end

  def _process_cie(value)
    result = [custom_field_object.name]
    op = value.values_at(:op).first
    case op
    when 'eq'
      result << "equals"
    when 'contains'
      result << "contains"
    when 'starts'
      result << "starts with"
    when 'ends'
      result << "ends with"
    when 'gt'
      result << ">"
    when 'lt'
      result << "<"
    when 'lteq'
      result << "<="
    when 'gteq'
      result << ">="
    else
      result << op
    end

    v = value.values_at(:v).first
    result << ((custom_field_object.field_type == 'number') ? v : "'#{v}'")
    result.join(' ')
  end

end
