class LineItem < ActiveRecord::Base

  # this is used only to pull the picture of the line_item. If after an order is created a product
  # is deleted then that product and all the pictures are gone. In that case line item should
  # display image not available. Besides image line_item should not pull any data from product and
  # instead used the attributes copied from product to line_item
  belongs_to :product

  belongs_to :order

  validates_presence_of :order_id
  validates_presence_of :product_id
  validates_numericality_of :quantity, minimum: 1

  def price
    self.product.price * self.quantity
  end
  alias_method :amount, :price

end
