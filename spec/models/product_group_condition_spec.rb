require 'spec_helper'

describe ProductGroupCondition do

  it "should raise error on nil name" do
    condition = ProductGroupCondition.new(operator: 'lt', value: 23)

    condition.wont_be(:valid?)
    condition.errors[:name].wont_be(:empty?)
  end

  it "should raise error on nil operator" do
    condition = ProductGroupCondition.new(name: 'price', value: 23)

    condition.wont_be(:valid?)
    condition.errors[:operator].wont_be(:empty?)
  end

  it "should raise error on nil value" do
    condition = ProductGroupCondition.new(name: 'price', operator: 'lt')
    condition.wont_be(:valid?)
    condition.errors[:value].wont_be(:empty?)
  end
end

describe ProductGroupCondition do
  describe "of type text" do
    let(:text_field) { create(:text_custom_field) }

    before do
      @condition = ProductGroupCondition.new({
        name: text_field.id, value: 't'
      })
    end

    it "should raise unsupported operator for non text operators" do
      %w(lt gt lteq gteq).each do | operator |
        @condition.operator = operator
        @condition.wont_be(:valid?)
        @condition.errors[:operator].must_equal ["is invalid"]
      end
    end

    it "should not raise unsupported operator for non text operators" do
      %w(contains starts ends eq).each do | operator |
        @condition.operator = operator
        @condition.must_be(:valid?)
      end
    end
  end

  describe "of type date" do
    let(:custom_field) { create(:date_custom_field) }

    before do
      @condition = ProductGroupCondition.new({
        name: custom_field.id, value: '1/1/2009'
      })
    end

    it "should raise unsupported operator for non text operators" do
      %w(contains starts ends).each do | operator |
        @condition.operator = operator
        @condition.wont_be(:valid?)
        @condition.errors[:operator].must_equal ["is invalid"]
      end
    end

    it "should not raise unsupported operator for non text operators" do
      %w(lt gt lteq gteq).each do | operator |
        @condition.operator = operator
        @condition.must_be(:valid?)
      end
    end
  end


  describe "of type number" do
    let(:custom_field) { create(:number_custom_field) }

    before do
      @condition = ProductGroupCondition.new({
        name: custom_field.id, value: 43
      })
    end

    it "should raise error with text value" do
      @condition.operator = 'lt'
      @condition.value = 'lt'
      @condition.wont_be(:valid?)
      @condition.errors[:value].must_equal ["is invalid"]
    end

    it "should raise unsupported operator for non text operators" do
      %w(contains starts ends).each do | operator |
        @condition.operator = operator
        @condition.wont_be(:valid?)
        @condition.errors[:operator].must_equal ["is invalid"]
      end
    end

    it "should not raise unsupported operator for non text operators" do
      %w(lt gt lteq gteq).each do | operator |
        @condition.operator = operator
        @condition.must_be(:valid?)
      end
    end
  end

  describe "when condition belongs to custom field" do
    let(:condition) do
      ProductGroupCondition.new(name: field.id, operator: 'contains', value: "test")
    end

    describe "of type text" do
      let(:field) { create(:text_custom_field) }

      it "should write sql by joining custom field answers table" do
        condition.index = 1
        condition.join(Product.arel_table).to_sql.must_be_like %{
          SELECT FROM "products" INNER JOIN "custom_field_answers" "answers1" ON "answers1"."product_id" = "products"."id"
        }
      end

      it "should return value as query column" do
        condition.query_column.must_equal :value
      end

      it "should return where clause with answers1.value" do
        condition.index=2
        condition.where.to_sql.must_be_like %Q{
          "answers2"."value" ILIKE '%test%'
        }
      end
    end
  end

  describe "when condition belongs to core field" do
    let(:condition) do
      ProductGroupCondition.new(name: "price", operator: 'lt', value: "23")
    end
    it "should not join table with custom field answer" do
      condition.index = 1
      condition.join(Product.arel_table).must_equal Product.arel_table
    end

    it "should return price as query column" do
      condition.query_column.must_equal :price
    end
    it "should return where clause with products.price" do
      condition.where.to_sql.must_be_like %Q{
        "products"."price\" < 23
      }
    end
  end
end
