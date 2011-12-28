require 'spec_helper'

describe 'product search module' do
  describe "#resolve_condition_klass" do
    it "should return TextCondition for name" do
      klass = Product.send(:resolve_condition_klass, 'name')
      klass.must_equal Search::TextCondition
    end

    it "should return TextCondition for description" do
      klass = Product.send(:resolve_condition_klass, 'description')
      klass.must_equal Search::TextCondition
    end

    it "should return NumberCondition for price" do
      klass = Product.send(:resolve_condition_klass, 'price')
      klass.must_equal Search::NumberCondition
    end

    it "should return NumberQuestion for number custom field" do
      q = create(:number_custom_field)
      klass = Product.send(:resolve_condition_klass, "q#{q.id}")
      klass.must_equal Search::NumberCondition
    end

    it "should return TextFieldQuestion for text custom field" do
      q = create(:text_custom_field)
      klass = Product.send(:resolve_condition_klass, "q#{q.id}")
      klass.must_equal Search::TextCondition
    end

    it "should return DateQuestion for date custom field" do
      q = create(:date_custom_field)
      klass = Product.send(:resolve_condition_klass, "q#{q.id}")
      klass.must_equal Search::DateCondition
    end
  end
end
