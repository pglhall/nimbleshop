require 'spec_helper'

describe Search::NumberField do
  before do
    @product1 = create(:product, price: 23, name: 'baby oil')
    @product2 = create(:product, price: 3,  name: 'baby lotion')
    @product3 = create(:product, price: 73, name: 'men pants')
    @product4 = create(:product, price: 123,name: 'khakis')
  end

  it "should find all products whose price is greater than 120" do
    Product.search(price: { op: 'gt', v: 120 }).must_equal [ @product4 ]
  end

  it "should find all products whose price is less than 120 less than 23" do
    Product.search([{ price: { op: 'gt', v: 23 } }, { price: { op: 'lt', v: 120 }}]).must_equal [  @product3 ]
  end
end
