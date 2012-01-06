class ProductGroup < ActiveRecord::Base

  has_many :product_group_conditions

  include BuildPermalink


  validates :name, presence: true

  # determines if the given product exists in the product group
  def exists?(product)
    products.include?(product)
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
