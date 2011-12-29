require 'spec_helper'

describe 'product search module' do
  describe "#resolve_condition_klass" do
    it "should return TextAnswer for name" do
      klass = Product.send(:resolve_condition_klass, 'name')
      klass.must_equal Search::TextField
    end

    it "should return TextAnswer for description" do
      klass = Product.send(:resolve_condition_klass, 'description')
      klass.must_equal Search::TextField
    end

    it "should return NumberAnswer for price" do
      klass = Product.send(:resolve_condition_klass, 'price')
      klass.must_equal Search::NumberField
    end

    it "should return NumberQuestion for number custom field" do
      q = create(:number_custom_field)
      klass = Product.send(:resolve_condition_klass, "q#{q.id}")
      klass.must_equal Search::NumberAnswer
    end

    it "should return TextFieldQuestion for text custom field" do
      q = create(:text_custom_field)
      klass = Product.send(:resolve_condition_klass, "q#{q.id}")
      klass.must_equal Search::TextAnswer
    end

    it "should return DateQuestion for date custom field" do
      q = create(:date_custom_field)
      klass = Product.send(:resolve_condition_klass, "q#{q.id}")
      klass.must_equal Search::DateAnswer
    end
  end
end
