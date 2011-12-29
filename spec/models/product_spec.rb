require 'spec_helper'

describe Product do

  describe "#to_param" do
    it "should return permalink" do
      p = Product.new(permalink: 'test')
      p.to_param.must_equal 'test'
    end
  end

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
      Product.search("q#{number.id}" => { op: 'eq', v: 23 }).must_equal [ p1 ]
      Product.search("q#{number.id}" => { op: 'eq', v: 73 }).must_equal [ p2 ]

      Product.search("q#{text.id}" => { op: 'eq', v: 'steve jobs' }).must_equal [ p3 ]
      Product.search("q#{text.id}" => { op: 'eq', v: 'george murphy' }).must_equal [ p2 ]

      Product.search("q#{date.id}" => { op: 'eq', v: '6/7/2010' }).must_equal [ p5 ]
      Product.search("q#{date.id}" => { op: 'eq', v: '8/5/2009' }).must_equal [ p4 ]
    end

    it "should show results to greater than operator" do
      Product.search("q#{number.id}" => { op: 'gt', v: 73 }).must_equal [ p3, p5 ]
      Product.search("q#{number.id}" => { op: 'gt', v: 93 }).must_equal [ p5 ]

      Product.search("q#{date.id}" => { op: 'gt', v: '6/7/2010' }).must_equal [ p3 ]
      Product.search("q#{date.id}" => { op: 'gt', v: '8/5/2009' }).must_equal [ p1, p3, p5 ]
    end

    it "should show results to less than operator" do
      Product.search("q#{number.id}" => { op: 'lt', v: 73 }).must_equal [ p1 ]
      Product.search("q#{number.id}" => { op: 'lt', v: 93 }).must_equal [ p1, p2, p3 ]
    end

    it "should show results to contains operator" do
      Product.search("q#{text.id}" => { op: 'contains', v: 'george' }).must_equal [p1, p2]
      Product.search("q#{text.id}" => { op: 'contains', v: 'job' }).must_equal [ p3 ]
    end

    it "should show results to starts with operator" do
      Product.search("q#{text.id}" => { op: 'starts', v: 'george' }).must_equal [p1, p2]
      Product.search("q#{text.id}" => { op: 'starts', v: 'bill' }).must_equal [ p4 ]
    end

    it "should show results to ends with operator" do
      Product.search("q#{text.id}" => { op: 'ends', v: 'gates' }).must_equal [ p4 ]
      Product.search("q#{text.id}" => { op: 'ends', v: 'bill' }).must_equal []
    end

    it "should show results for mixed operators" do
      Product.search("q#{number.id}" => { op: 'gt', v: 22 }, "q#{number.id}" =>{ op: 'lt', v: 24}).sort.must_equal [ p1 ]
      Product.search("q#{number.id}" => { op: 'gt', v: 22 }, "q#{number.id}" => { op: 'lt', v: 77}).sort.must_equal [ p1, p2, p3 ]
    end
  end
  describe 'search for mixed models' do
    let(:category) { create(:text_custom_field)    }
    let(:price)    { create(:number_custom_field)  }

    let(:pg_bangles) { ProductGroup.create!(name: 'bangles', :condition => {"q#{category.id}" => { op: 'eq', v: 'bangle'}}) }
    let(:pg_price) { ProductGroup.create!(name: 'price', :condition => {"q#{price.id}" => { op: 'lt', v: 50}}) }

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

    #bad_sql = %Q{
#SELECT "products".* FROM "products" INNER JOIN "custom_field_answers" ON "custom_field_answers"."product_id" = "products"."id" WHERE ("custom_field_answers"."value" ILIKE 'bangle') AND ("custom_field_answers"."number_value" < 50)
    #}

    #sql = %Q{
#SELECT p.*
#FROM "products" AS p
#INNER JOIN "custom_field_answers" AS a1 ON p."id" = a1."product_id"
#INNER JOIN "custom_field_answers" AS a2 ON p."id" = a1."product_id"
#WHERE a1."value" = 'bangle' AND a2."number_value" < 50
    #}

    it "should show results" do
      products = Product.search("q#{category.id}" => { op: 'eq', v: 'bangle' },"q#{price.id}" => { op: 'lt', v: 50})
      skip "subba will later look into it" do
        products.must_equal [p1]
      end
    end

  end
end

