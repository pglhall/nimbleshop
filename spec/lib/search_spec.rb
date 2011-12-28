require 'spec_helper'

describe 'product search module' do
  describe "#resolve_condition_klass" do

    describe "when name is key" do

      it "should return TextCondition" do
        klass = Product.send(:resolve_condition_klass, 'name')
        klass.must_equal Search::TextCondition
      end
    end
  end
end
