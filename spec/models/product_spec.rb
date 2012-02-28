require 'spec_helper'

describe Product do

  describe "#initialize_status" do
    it "sets status as active" do
      product = Product.new
      product.status.must_equal 'active'
    end

    it "wont update status" do
      product = Product.new(status: 'hidden')
      product.status.must_equal 'hidden'
    end
  end

  it 'should create a default picture record' do
    product = create(:product)
    product.pictures.size.must_equal 1
  end

  it "needs alias title" do
    product = Product.new(name: 'welcome')
    product.title.must_equal 'welcome'
  end

  describe "#to_param" do
    it "should return permalink" do
      p = Product.new(permalink: 'test')
      p.to_param.must_equal 'test'
    end
  end

  describe "status based scopes" do
    before do
      @product1 = create(:product, status: 'active')
      @product2 = create(:product, status: 'hidden')
      @product3 = create(:product, status: 'hidden')
      @product4 = create(:product)
      @product5 = create(:product, status: 'sold_out')
    end

    it { 
      Product.active.must_have_same_elements [ @product1, @product4 ] 
    }

    it { 
      Product.hidden.must_have_same_elements [ @product2, @product3 ] 
    }

    it { 
      Product.sold_out.must_have_same_elements  [ @product5 ] 
    }
  end

  describe "#find_or_build_for_field" do
    before do
      @product = create(:product)
      @field1  = create(:text_custom_field)
      @field2  = create(:number_custom_field)
      @answer  = @product.custom_field_answers.create(custom_field: @field1, value: 23)
    end

    it "needs to build new answer" do
      answer = @product.find_or_build_answer_for_field(@field2)
      answer.id.must_be_nil
    end

    it "needs to return exisitng answer" do
      @product.find_or_build_answer_for_field(@field1).must_equal @answer
    end
  end
end
