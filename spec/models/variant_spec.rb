require 'spec_helper'

describe Variant do
  describe "uniqueness validations" do

    describe "all three variations active" do
      let(:product) { create(:product) }
      before do
        @variant1 = create(:variant, product: product)
        @variant1.save!
        @variant2 = build(:variant, product: product)
        @variant2.save
      end
      it 'should have error' do
        @variant2.errors.full_messages.sort.must_equal ["Already a record exists for combination v1, v2, and v3"]
      end
    end
    describe "two variations active" do
      let(:product) { create(:product) }
      before do
        product.variation3.update_attributes!(active: false)
        @variant1 = build(:variant, product: product)
        @variant1.save!
        @variant2 = build(:variant, product: product)
        @variant2.save
      end
      it 'should have error' do
        @variant2.errors.full_messages.sort.must_equal ["Already a record exists for combination v1 and v2"]
      end
    end
    describe "one variation active" do
      let(:product) { create(:product) }
      before do
        product.variation2.update_attributes!(active: false)
        product.variation3.update_attributes!(active: false)
        @variant1 = build(:variant, product: product)
        @variant1.save!
        @variant2 = build(:variant, product: product)
        @variant2.save
      end
      it 'should have error' do
        @variant2.errors.full_messages.sort.must_equal ["Already a record exists for combination v1"]
      end
    end

  end

  describe "presence validations" do

    describe "all three variations active" do
      let(:product) { create(:product)    }
      before do
        @variant1 = build(:variant, product: product, variation1_value: nil,
                                                                            variation2_value: nil, variation3_value: nil)
        @variant1.save

        @variant2 = build(:variant, product: product, variation1_value: nil, variation2_value: nil, price: nil)
        @variant2.save
      end
      it '' do
        expected = ["Color should not be empty", "Material should not be empty", "Size should not be empty"]
        @variant1.errors.full_messages.sort.must_equal expected

        expected = ["Color should not be empty", "Price can't be blank", "Size should not be empty"]
        @variant2.errors.full_messages.sort.must_equal expected
      end
    end
    describe "only two variations active" do
      let(:product) { create(:product)    }
      before do
        product.variation3.update_attributes!(active: false)
        @variant1 = build(:variant, product: product, variation1_value: nil, variation2_value: nil,
                                                                                                variation3_value: nil)
        @variant1.save

        @variant2 = build(:variant, product: product)
        @variant2.save
      end
      it '' do
        expected = ["Color should not be empty", "Size should not be empty"]
        @variant1.errors.full_messages.sort.must_equal expected

        @variant2.variation3_value.must_equal nil
      end
    end

  end
end
