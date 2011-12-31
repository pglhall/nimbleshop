require 'spec_helper'

describe ProductGroup do
  describe '#exists?' do
    let(:p1) { create(:product) }
    let(:p2) { create(:product) }
    let(:cf) { CustomField.create!(name: 'category', field_type: 'text') }

    let(:pg1) do 
      create(:product_group, name: 'bangles', condition: {"q#{cf.id}" => { op: 'eq', v: 'bangle'}})
    end

    before do
      p1.custom_field_answers.create(custom_field: cf, value: 'bangle')
      p2.custom_field_answers.create(custom_field: cf, value: 'necklace')
    end
    it '' do
      pg1.exists?(p1).must_equal true
      pg1.exists?(p2).must_equal false
    end
  end
end
