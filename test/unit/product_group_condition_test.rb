require "test_helper"

class ProductGroupConditonTest < ActiveSupport::TestCase

  test "operators for number" do
    condition = build(:number_group_condition)

    %w(lt gt lteq gteq).each do | operator |
      condition.operator = operator
      assert condition.valid?
    end

    %w(contains starts ends).each do | operator |
      condition.operator = operator
      refute condition.valid?
      assert_equal ["is invalid"], condition.errors[:operator]
    end
  end

  test "valid operators for text" do
    condition = build(:text_group_condition)

    %w(contains starts ends eq).each do | operator |
      condition.operator = operator
      assert condition.valid?
    end

    %w(lt gt lteq gteq).each do | operator |
      condition.operator = operator
      refute condition.valid?
    end
  end

  test "operators for date" do
    condition = build(:date_group_condition)

    %w(lt gt lteq gteq).each do | operator |
      condition.operator = operator
      assert condition.valid?
    end

    %w(contains starts ends).each do | operator |
      condition.operator = operator
      refute condition.valid?
    end
  end

end


class ProductGroupConditionNumber < ActiveSupport::TestCase
  setup do
    @condition = build(:number_group_condition)
    @product_group = ProductGroup.new
    @condition.value    = "4"
    @product_group.product_group_conditions = [ @condition ]
  end

  test 'less than condition' do
    @condition.operator = "lt"
    expected =  %{
      SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" WHERE "answers0"."number_value" < 4.0 AND "products"."status" = 'active'
    }
    assert_must_be_like expected, @product_group.product_group_conditions.to_search_sql
  end

  test 'less than equal condition' do
    @condition.operator = "lteq"
    expected =  %{
      SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" WHERE "answers0"."number_value" <= 4.0 AND "products"."status" = 'active'
    }
    assert_must_be_like expected, @product_group.product_group_conditions.to_search_sql
  end

  test 'greater than operation' do
    @condition.operator = "gt"
    expected = %{
      SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" WHERE "answers0"."number_value" > 4.0 AND "products"."status" = 'active'
    }
    assert_must_be_like expected, @product_group.product_group_conditions.to_search_sql
  end

  test 'greater than equal condition' do
    @condition.operator = "gteq"
    expected  = %{
      SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" WHERE "answers0"."number_value" >= 4.0 AND "products"."status" = 'active'
    }
    assert_must_be_like expected, @product_group.product_group_conditions.to_search_sql
  end

  test 'equal operation' do
    @condition.operator = "eq"
    expected  = %{
      SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" WHERE "answers0"."number_value" = 4.0 AND "products"."status" = 'active'
    }
    assert_must_be_like expected, @product_group.product_group_conditions.to_search_sql
  end
end

class ProductGroupConditionWithMultipleConditions < ActiveSupport::TestCase

  include DbifySqlHelper

  setup do
    @condition1 = build :number_group_condition
    @condition2 = build :text_group_condition
    @product_group = ProductGroup.new

    @condition1.value  = "4.34"
    @condition2.value  = "george"
  end

  test "should handle less than operation and contains" do
    @condition1.operator = "lt"
    @condition2.operator = "contains"
    @product_group.product_group_conditions = [ @condition1, @condition2 ]
    search_sql = @product_group.product_group_conditions.to_search_sql
    expected_sql = %{
      SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" INNER JOIN "custom_field_answers" "answers1" ON "answers1"."product_id" = "products"."id" WHERE "answers0"."number_value" < 4.34 AND "answers1"."value" LIKE '%george%' AND "products"."status" = 'active'
    }
    assert_must_be_like dbify_sql(expected_sql), search_sql
  end

  test "should handle less than equal operation and starts with" do
    @condition1.operator = "lteq"
    @condition2.operator = "starts"
    @product_group.product_group_conditions = [ @condition1, @condition2 ]
    search_sql = @product_group.product_group_conditions.to_search_sql

    expected_sql = %{
      SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" INNER JOIN "custom_field_answers" "answers1" ON "answers1"."product_id" = "products"."id" WHERE "answers0"."number_value" <= 4.34 AND "answers1"."value" LIKE 'george%' AND "products"."status" = 'active'
    }
    assert_must_be_like dbify_sql(expected_sql), search_sql
  end

  test "should handle greater than operation and ends with" do
    @condition1.operator = "gt"
    @condition2.operator = "ends"
    @product_group.product_group_conditions = [ @condition1, @condition2 ]
    search_sql = @product_group.product_group_conditions.to_search_sql
    expected_sql = %{
      SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" INNER JOIN "custom_field_answers" "answers1" ON "answers1"."product_id" = "products"."id" WHERE "answers0"."number_value" > 4.34 AND "answers1"."value" LIKE '%george' AND "products"."status" = 'active'
    }
    assert_must_be_like dbify_sql(expected_sql), search_sql
  end

  test "should handle greater than equal  operation" do
    @condition1.operator = "gteq"
    @condition2.operator = "eq"
    @product_group.product_group_conditions = [ @condition1, @condition2 ]
    search_sql = @product_group.product_group_conditions.to_search_sql
    expected_sql = %{
      SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" INNER JOIN "custom_field_answers" "answers1" ON "answers1"."product_id" = "products"."id" WHERE "answers0"."number_value" >= 4.34 AND "answers1"."value" LIKE 'george' AND "products"."status" = 'active'
    }
    assert_must_be_like dbify_sql(expected_sql), search_sql
  end

  test "should handle equal operation and equal" do
    @condition1.operator = "eq"
    @condition2.operator = "eq"
    @product_group.product_group_conditions = [ @condition1, @condition2 ]
    search_sql = @product_group.product_group_conditions.to_search_sql
    expected_sql = %{
      SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" INNER JOIN "custom_field_answers" "answers1" ON "answers1"."product_id" = "products"."id" WHERE "answers0"."number_value" = 4.34 AND "answers1"."value" LIKE 'george' AND "products"."status" = 'active'
    }

    assert_must_be_like dbify_sql(expected_sql), search_sql
  end

  test "with price_group_condition search" do
    @condition3 = create :price_group_condition
    @condition1.value  = "4.34"
    @condition2.value  = "george"
    @condition3.value  = "19.99"
    @condition1.operator = "lt"
    @condition2.operator = "starts"
    @condition3.operator = "gteq"
    @product_group.product_group_conditions = [ @condition1, @condition2, @condition3 ]
    search_sql = @product_group.product_group_conditions.to_search_sql

    expected_sql = %{
      SELECT products.* FROM "products" INNER JOIN "custom_field_answers" "answers0" ON "answers0"."product_id" = "products"."id" INNER JOIN "custom_field_answers" "answers1" ON "answers1"."product_id" = "products"."id" WHERE "answers0"."number_value" < 4.34 AND "answers1"."value" LIKE 'george%' AND "products"."price" >= 19.99 AND "products"."status" = 'active'
    }

    assert_must_be_like dbify_sql(expected_sql), search_sql
  end

end
