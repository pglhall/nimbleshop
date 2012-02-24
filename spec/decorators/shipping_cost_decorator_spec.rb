require 'spec_helper'

describe ShippingCostDecorator do

  describe "#shipping_cost" do
    describe "shipping method is nil" do
      let(:order) { Order.new }
      let(:shipping) { ShippingCostDecorator.new(order) }
      it {  shipping.shipping_cost.must_equal 0 }
    end

    describe "shipping method is not nil" do
      let(:order) { mock(:shipping_method => shipping_method) }
      let(:shipping_method) { mock(:shipping_cost => 3.99) }
      let(:shipping) { ShippingCostDecorator.new(order) }
      it {  shipping.shipping_cost.must_equal 3.99 }
    end
  end
end
