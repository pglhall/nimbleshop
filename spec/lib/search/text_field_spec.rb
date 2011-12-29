require 'spec_helper'

describe Search::TextField do
  before do
    @product1 = create(:product, price: 23, name: 'baby oil')
    @product2 = create(:product, price: 3,  name: 'baby lotion')
    @product3 = create(:product, price: 73, name: 'men pants')
    @product4 = create(:product, price: 123,name: 'khakis')
  end

  it "should find all products whose price is greater than 120" do
    Product.search(price: { op: 'gt', v: 120 }).must_equal [ @product4 ]
  end

  it "should find all products whose price is less than 120" do
    Product.search(price: { op: 'lt', v: 120 }).must_equal [ @product1, @product2, @product3 ]
  end

  it "should find all products whose price is equal to 3" do
    Product.search(price: { op: 'eq', v: 3 }).must_equal [ @product2 ]
  end

  it "should find all products whose price is grater than 20 and name starts with baby" do
    Product.search(price: { op: 'lt', v: 20 }, name: { op: 'starts', v:'baby'}).must_equal [ @product2 ]
  end

  it "should find all products whose price is grater than 20 and name starts with men" do
    Product.search(price: { op: 'gt', v: 3 }, name: { op: 'starts', v:'men'}).must_equal  [ @product3 ]
  end
end
