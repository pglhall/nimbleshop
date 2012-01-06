class ProductGroup < ActiveRecord::Base

  has_many :product_group_conditions

  accepts_nested_attributes_for :product_group_conditions, allow_destroy: true

  include BuildPermalink


  validates :name, presence: true

  # determines if the given product exists in the product group
  def exists?(product)
    products.include?(product)
  end

  def self.fields
    c = []
    c << { "id" => 'name', "name" => 'Name', "field_type" => 'text' }
    c << { "id" => 'price', "name" => 'Price', "field_type" => 'number' }

    CustomField.all.map do | field |
      c << field.attributes.slice("id", "name", "field_type")
    end

    c 
  end

  def self.operators
    {
      text: [['Contains', 'contains'], ['Starts With','starts'], ['Ends With','ends']],
      number: [['Equal To', 'eq'], ['Greater Than', 'gt'], ['Less Than', 'lt'], ['Greater Than Equal To', 'gteq'], ['Less Than Equal To', 'lteq']],
      date: [['On', 'eq'], ['After', 'gt'], ['Before', 'lt'], ['On or After', 'gteq'], ['On or Before', 'lteq']],
    }
  end

  def products
    join_proxy = Product.arel_table
    product_group_conditions.each_with_index do | condition, index |
      condition.index = index
      join_proxy = condition.join(join_proxy)
    end

    where_proxy = nil

    product_group_conditions.each do | condition |
      where_proxy = condition.where(where_proxy)
    end

    sql = join_proxy.where(where_proxy).project(Arel.sql("products.*")).to_sql

    Product.find_by_sql(sql)
  end

  def summarize
    product_group_conditions.map(&:summary).join('  and ')
  end

   # list of all product groups containing input product
  def self.contains_product(product)
    self.all.select do |pg|
      pg.exists?(product)
    end
  end
end
