require 'spec_helper'
require 'ruby-debug'

describe ProductGroupCondition, " instance" do

  let(:condition) do
    ProductGroupCondition.new(name: 'price', operator: 'lt', value: 23)
  end

  it "should raise error on nil name" do
    condition.name = nil
    condition.valid?

    condition.errors[:name].wont_be(:empty?)
  end

  it "should raise error on nil operator" do
    condition.operator = nil
    condition.valid?

    condition.errors[:operator].wont_be(:empty?)
  end

  it "should raise error on nil value" do
    condition.value = nil
    condition.valid?

    condition.errors[:value].wont_be(:empty?)
  end
end

describe ProductGroupCondition do
  describe "when condition belongs to custom field" do
    let(:condition) do
      ProductGroupCondition.new(name: "#{field.id}", operator: 'contains', value: "test")
    end

    describe "of type text" do
      let(:field) { create(:text_custom_field) }

      it "should raise validation error for unsupported operators" do
        condition.operator = "lt"
        condition.valid?

        condition.errors[:operator].wont_be(:empty?)
      end

      it "should not raise validation error for supported operators" do
        condition.operator = "contains"
        condition.valid?

        condition.errors[:operator].must_be(:empty?)
      end

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
