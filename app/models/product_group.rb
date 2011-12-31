class ProductGroup < ActiveRecord::Base

  attr_accessor :custom_field_id, :custom_field_operator, :custom_field_value

  include BuildPermalink

  serialize :condition

  validates :name, presence: true
  validates :custom_field_id, presence: true, :if => lambda { |record| record.condition.blank? }

  # determines if the given product exists in the product group
  def exists?(product)
    products.include?(product)
  end

  def products
    Product.search(condition)
  end

  def summarize
    Product.summarize(condition)
  end
end
