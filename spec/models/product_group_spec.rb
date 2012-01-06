require 'spec_helper'

describe ProductGroup do
  describe "#search" do
    let(:text)    { create(:text_custom_field)    }
    let(:date)    { create(:date_custom_field)    }
    let(:number)  { create(:number_custom_field)  }

    let(:p1) { create(:product) }
    let(:p2) { create(:product) }
    let(:p3) { create(:product) }
    let(:p4) { create(:product) }
    let(:p5) { create(:product) }

    before do
      p1.custom_field_answers.create(custom_field: number, value: 23)
      p2.custom_field_answers.create(custom_field: number, value: 73)
      p3.custom_field_answers.create(custom_field: number, value: 75)
      p5.custom_field_answers.create(custom_field: number, value: 179)

      p1.custom_field_answers.create(custom_field: text, value: 'george washington')
      p2.custom_field_answers.create(custom_field: text, value: 'george murphy')
      p3.custom_field_answers.create(custom_field: text, value: 'steve jobs')
      p4.custom_field_answers.create(custom_field: text, value: 'bill gates')

      p1.custom_field_answers.create(custom_field: date, value: '12/2/2009')
      p2.custom_field_answers.create(custom_field: date, value: '1/15/2008')
      p3.custom_field_answers.create(custom_field: date, value: '2/7/2011')
      p4.custom_field_answers.create(custom_field: date, value: '8/5/2009')
      p5.custom_field_answers.create(custom_field: date, value: '6/7/2010')
    end

    it "should show results to equality operator" do
      group     = create(:product_group)
      condition = group.product_group_conditions.create(name: number.id.to_s, operator: 'eq', value: 23)
      group.products.must_equal [p1]
      condition.value = 73
      group.products.must_equal [p2]
    end

    it "should return products with multiple vlaues" do
      group     = create(:product_group)
      group.product_group_conditions.create(name: number.id.to_s, operator: 'lt', value: 25)
      group.product_group_conditions.create(name: text.id.to_s, operator: 'starts', value: 'george')

      group.products.must_equal [p1]
    end
=begin
    it "should show results to equality operator" do
      Product.search(number.id => { op: 'eq', v: 23 }).must_equal [ p1 ]
      Product.search(number.id => { op: 'eq', v: 73 }).must_equal [ p2 ]

      Product.search(text.id => { op: 'eq', v: 'steve jobs' }).must_equal [ p3 ]
      Product.search(text.id => { op: 'eq', v: 'george murphy' }).must_equal [ p2 ]

      Product.search(date.id => { op: 'eq', v: '6/7/2010' }).must_equal [ p5 ]
      Product.search(date.id => { op: 'eq', v: '8/5/2009' }).must_equal [ p4 ]
    end

    it "should show results to greater than operator" do
      Product.search(number.id => { op: 'gt', v: 73 }).must_equal [ p3, p5 ]
      Product.search(number.id => { op: 'gt', v: 93 }).must_equal [ p5 ]

      Product.search(date.id => { op: 'gt', v: '6/7/2010' }).must_equal [ p3 ]
      Product.search(date.id => { op: 'gt', v: '8/5/2009' }).must_equal [ p1, p3, p5 ]
    end

    it "should show results to less than operator" do
      Product.search(number.id => { op: 'lt', v: 73 }).must_equal [ p1 ]
      Product.search(number.id => { op: 'lt', v: 93 }).must_equal [ p1, p2, p3 ]
    end

    it "should show results to contains operator" do
      Product.search(text.id => { op: 'contains', v: 'george' }).must_equal [p1, p2]
      Product.search(text.id => { op: 'contains', v: 'job' }).must_equal [ p3 ]
    end

    it "should show results to starts with operator" do
      Product.search(text.id => { op: 'starts', v: 'george' }).must_equal [p1, p2]
      Product.search(text.id => { op: 'starts', v: 'bill' }).must_equal [ p4 ]
    end

    it "should show results to ends with operator" do
      Product.search(text.id => { op: 'ends', v: 'gates' }).must_equal [ p4 ]
      Product.search(text.id => { op: 'ends', v: 'bill' }).must_equal []
    end

    it "should show results for mixed operators" do
      Product.search(number.id => { op: 'gt', v: 22 }, "q#{number.id}" =>{ op: 'lt', v: 24}).sort.must_equal [ p1 ]
      Product.search(number.id => { op: 'gt', v: 22 }, "q#{number.id}" => { op: 'lt', v: 77}).sort.must_equal [ p1, p2, p3 ]
    end
=end
  end
=begin
  describe 'search for mixed models' do
    let(:category) { create(:text_custom_field)    }
    let(:price)    { create(:number_custom_field)  }

    let(:pg_bangles) { ProductGroup.create!(name: 'bangles', :condition => { category.id => { op: 'eq', v: 'bangle'}}) }
    let(:pg_price) { ProductGroup.create!(name: 'price', :condition => { price.id => { op: 'lt', v: 50}}) }

    let(:p1) { create(:product) }
    let(:p2) { create(:product) }
    let(:p3) { create(:product) }
    let(:p4) { create(:product) }

    before do
      p1.custom_field_answers.create(custom_field: price, value: 23)
      p1.custom_field_answers.create(custom_field: category, value: 'bangles')
      p2.custom_field_answers.create(custom_field: price, value: 73)
      p2.custom_field_answers.create(custom_field: category, value: 'necklace')
    end

    it "should show results" do
      products = Product.search(category.id => { op: 'eq', v: 'bangle' }, price.id => { op: 'lt', v: 50})
      skip "subba will later look into it" do
        products.must_equal [p1]
      end
    end
  end
=end
end
