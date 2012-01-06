require 'spec_helper'

describe Product do

  describe "#to_param" do
    it "should return permalink" do
      p = Product.new(permalink: 'test')
      p.to_param.must_equal 'test'
    end
  end

  describe "#find_or_build_for_field" do
    before do
      @product = create(:product)
      @field1  = create(:text_custom_field)
      @field2  = create(:number_custom_field)
      @answer  = @product.custom_field_answers.create(custom_field: @field1, value: 23)
    end

    it "should build new custom field answer" do
      answer = @product.find_or_build_answer_for_field(@field2)
      answer.id.must_be_nil
    end

    it "should return existing custom field answer" do
      @product.find_or_build_answer_for_field(@field1).must_equal @answer
    end
  end

end
