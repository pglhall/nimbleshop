module Product::Scopes
  extend ActiveSupport::Concern

  included do
    ProductGroup.scoped.each do |product_group|
      Product.scope product_group.name, lambda {
        relation = Product.scoped
        pg_conditions = ProductGroupCondition.where(product_group_id: product_group.id)
        pg_conditions.inject(Product.scoped) do |relation, pg_condition|
          _relation = Product.where("#{pg_condition.column_name} #{pg_condition.operator} #{pg_condition.value_integer}")
          relation.merge(_relation)
        end
      }
    end
  end

end
