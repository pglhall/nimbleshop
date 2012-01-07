class ProductGroupCondition < ActiveRecord::Base
  include Search
  belongs_to :product_group
  validates_presence_of :name, :operator, :value
end
