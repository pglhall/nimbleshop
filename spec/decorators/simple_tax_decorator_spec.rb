require 'spec_helper'

describe SimpleTaxDecorator do

  describe "#compute_tax" do
    let(:order) { Order.new }
    let(:shop)  { Shop.new(tax_percentage: 5) }

    let(:tax_decorator) { SimpleTaxDecorator.new(order, shop) }

    it {
      order.expects(:price).returns(300)
      tax_decorator.tax.to_f.must_equal 15.0
    }
  end
end
