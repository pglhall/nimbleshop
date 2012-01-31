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
    let(:condition) { build(:text_group_condition) }

    it "should raise unsupported operator for non text operators" do
      %w(lt gt lteq gteq).each do | operator |
        condition.operator = operator
      condition.wont_be(:valid?)
      condition.errors[:operator].must_equal ["is invalid"]
      end
    end

    it "should not raise unsupported operator for text operators" do
      %w(contains starts ends eq).each do | operator |
        condition.operator = operator
      condition.must_be(:valid?)
      end
    end
  end

  describe "of type date" do
    let(:condition) { build(:date_group_condition) }

    it "should raise unsupported operator for non text operators" do
      %w(contains starts ends).each do | operator |
        condition.operator = operator
      condition.wont_be(:valid?)
      condition.errors[:operator].must_equal ["is invalid"]
      end
    end

    it "should not raise unsupported operator for date operators" do
      %w(lt gt lteq gteq).each do | operator |
        condition.operator = operator
      condition.must_be(:valid?)
      end
    end
  end

  describe "of type number" do
    let(:condition) { build(:number_group_condition) }

    it "should raise error with non number value" do
      condition.value = 'lt'
      condition.wont_be(:valid?)
      condition.errors[:value].must_equal ["is invalid"]
    end

    it "should raise unsupported operator for non text operators" do
      %w(contains starts ends).each do | operator |
        condition.operator = operator
      condition.wont_be(:valid?)
      condition.errors[:operator].must_equal ["is invalid"]
      end
    end

    it "should not raise unsupported operators" do
      %w(lt gt lteq gteq).each do | operator |
        condition.operator = operator
      condition.must_be(:valid?)
      end
    end

    describe "#to_search_sql" do

      let(:product_group) { ProductGroup.new }
      let(:search_sql) {  product_group.product_group_conditions.to_search_sql }

      before do
        condition.value    = "4"
        product_group.product_group_conditions = [ condition ]
      end

      it "should handle less than operation" do
        condition.operator = "lt"

        search_sql.must_be_like %{
      SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" WHERE "answers0"."number_value" < 4.0
        }
      end

      it "should handle less than equal operation" do
        condition.operator = "lteq"

        search_sql.must_be_like %{
      SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" WHERE "answers0"."number_value" <= 4.0
        }
      end

      it "should handle greater than operation" do
        condition.operator = "gt"
        search_sql.must_be_like %{
      SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" WHERE "answers0"."number_value" > 4.0
        }
      end

      it "should handle greater than equal  operation" do
        condition.operator = "gteq"
        search_sql.must_be_like %{
      SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" WHERE "answers0"."number_value" >= 4.0
        }
      end

      it "should handle equal operation" do
        condition.operator = "eq"
        search_sql.must_be_like %{
      SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" WHERE "answers0"."number_value" = 4.0
        }
      end
    end
  end

  describe "with multiple conditions" do
    describe "#to_search_sql" do

      let(:condition1) { build(:number_group_condition) }
      let(:condition2) { build(:text_group_condition) }
      let(:product_group) { ProductGroup.new }
      let(:search_sql) {  product_group.product_group_conditions.to_search_sql }

      before do
        condition1.value  = "4.34"
        condition2.value  = "george"
        product_group.product_group_conditions = [ condition1, condition2 ]
      end

      it "should handle less than operation and contains" do
        condition1.operator = "lt"
        condition2.operator = "contains"

        expected_sql = %{
          SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" INNER JOIN "custom_field_answers" "answers1" ON "answers1"."product_id" = "products"."id" WHERE "answers0"."number_value" < 4.34 AND "answers1"."value" LIKE '%george%'
        }

        search_sql.must_be_like dbify_sql(expected_sql)
      end

      it "should handle less than equal operation and starts with" do
        condition1.operator = "lteq"
        condition2.operator = "starts"

        expected_sql = %{
          SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" INNER JOIN "custom_field_answers" "answers1" ON "answers1"."product_id" = "products"."id" WHERE "answers0"."number_value" <= 4.34 AND "answers1"."value" LIKE 'george%'
        }

        search_sql.must_be_like dbify_sql(expected_sql)
      end

      it "should handle greater than operation and ends with" do
        condition1.operator = "gt"
        condition2.operator = "ends"
        expected_sql = %{
          SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" INNER JOIN "custom_field_answers" "answers1" ON "answers1"."product_id" = "products"."id" WHERE "answers0"."number_value" > 4.34 AND "answers1"."value" LIKE '%george'
        }

        search_sql.must_be_like dbify_sql(expected_sql)
      end

      it "should handle greater than equal  operation" do
        condition1.operator = "gteq"
        condition2.operator = "eq"
        expected_sql = %{
          SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" INNER JOIN "custom_field_answers" "answers1" ON "answers1"."product_id" = "products"."id" WHERE "answers0"."number_value" >= 4.34 AND "answers1"."value" LIKE 'george'
        }

        search_sql.must_be_like dbify_sql(expected_sql)
      end

      it "should handle equal operation and equal" do
        condition1.operator = "eq"
        condition2.operator = "eq"
        expected_sql = %{
          SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" INNER JOIN "custom_field_answers" "answers1" ON "answers1"."product_id" = "products"."id" WHERE "answers0"."number_value" = 4.34 AND "answers1"."value" LIKE 'george'
        }

        search_sql.must_be_like dbify_sql(expected_sql)
      end

      describe "with price condition" do
        let(:condition3) { create(:price_group_condition) }

        before do
          condition1.value  = "4.34"
          condition2.value  = "george"
          condition3.value  = "19.99"
          condition1.operator = "lt"
          condition2.operator = "starts"
          condition3.operator = "gteq"
          product_group.product_group_conditions = [ condition1, condition2, condition3 ]
        end

        it "should handle search" do
          expected_sql = %{
            SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" INNER JOIN "custom_field_answers" "answers1" ON "answers1"."product_id" = "products"."id" WHERE "answers0"."number_value" < 4.34 AND "answers1"."value" LIKE 'george%' AND "products"."price" >= 19.99
          }

          search_sql.must_be_like dbify_sql(expected_sql)
        end
      end
    end
  end
end
