require 'spec_helper'

describe ProductGroup do
  describe '#exists?' do
    let(:p1) { create(:product) }
    let(:p2) { create(:product) }
    let(:cf) { CustomField.create!(name: 'category', field_type: 'text') }
    let(:pg1) { create(:product_group, name: 'bangles', condition: {"q#{cf.id}" => { op: 'eq', v: 'bangle'}}) }
    before do
      p1.custom_field_answers.create(custom_field: cf, value: 'bangle')
      p2.custom_field_answers.create(custom_field: cf, value: 'necklace')
    end
    it '' do
      pg1.exists?(p1).must_equal true
      pg1.exists?(p2).must_equal false
    end
  end

  describe 'condition_in_english' do
    describe 'field type is text' do
      let(:cf) { CustomField.create!(name: 'category', field_type: 'text') }
      let(:pg1) { create(:product_group, name: 'bangles', condition: {"q#{cf.id}" => { op: 'eq', v: 'bangle'}}) }
      let(:pg2) { create(:product_group, name: 'necklaces', condition: {"q#{cf.id}" => { op: 'contains', v: 'necklace'}}) }
      let(:pg3) { create(:product_group, name: 'pendants', condition: {"q#{cf.id}" => { op: 'starts', v: 'pendant'}}) }
      let(:pg4) { create(:product_group, name: 'earrings', condition: {"q#{cf.id}" => { op: 'ends', v: 'earrings'}}) }
      it '' do
        pg1.condition_in_english.must_equal "Category equals 'bangle'"
        pg2.condition_in_english.must_equal "Category contains 'necklace'"
        pg3.condition_in_english.must_equal "Category starts with 'pendant'"
        pg4.condition_in_english.must_equal "Category ends with 'earrings'"
      end
    end

    describe 'field type is number' do
      let(:cf) { CustomField.create!(name: 'price', field_type: 'number') }
      let(:pg1) { create(:product_group, name: '= 10', condition: {"q#{cf.id}" => { op: 'eq', v: 10}}) }
      let(:pg2) { create(:product_group, name: '> 10', condition: {"q#{cf.id}" => { op: 'gt', v: 10}}) }
      let(:pg3) { create(:product_group, name: '< 10', condition: {"q#{cf.id}" => { op: 'lt', v: 10}}) }
      let(:pg4) { create(:product_group, name: '<= 10', condition: {"q#{cf.id}" => { op: 'lteq', v: 10}}) }
      let(:pg5) { create(:product_group, name: '>= 10', condition: {"q#{cf.id}" => { op: 'gteq', v: 10}}) }
      it '' do
        pg1.condition_in_english.must_equal "Price equals 10"
        pg2.condition_in_english.must_equal "Price > 10"
        pg3.condition_in_english.must_equal "Price < 10"
        pg4.condition_in_english.must_equal "Price <= 10"
        pg5.condition_in_english.must_equal "Price >= 10"
      end
    end

    describe 'condition has more than one hash' do
      let(:cf) { CustomField.create!(name: 'price', field_type: 'number') }
      let(:pg1) { create(:product_group, name: '= 10', condition: {"q#{cf.id}" => [{ op: 'gt', v: 10},{ op: 'lt', v: 20}]}) }
      it '' do
        pg1.condition_in_english.must_equal "Price > 10 and price < 20"
      end
    end


  end
end


