require 'test_helper'

class ProductGroupTest < ActiveSupport::TestCase

  setup do
    @text = create :text_custom_field
    @date = create :date_custom_field
    @number = create :number_custom_field

    @p1 = create(:product)
    @p2 = create(:product)
    @p3 = create(:product)
    @p4 = create(:product)
    @p5 = create(:product)

    @p1.custom_field_answers.create(custom_field: @number, value: 23)
    @p2.custom_field_answers.create(custom_field: @number, value: 73)
    @p3.custom_field_answers.create(custom_field: @number, value: 75)
    @p5.custom_field_answers.create(custom_field: @number, value: 179)

    @p1.custom_field_answers.create(custom_field: @text, value: 'george washington')
    @p2.custom_field_answers.create(custom_field: @text, value: 'george murphy')
    @p3.custom_field_answers.create(custom_field: @text, value: 'steve jobs')
    @p4.custom_field_answers.create(custom_field: @text, value: 'bill gates')

    @p1.custom_field_answers.create(custom_field: @date, value: '12/2/2009')
    @p2.custom_field_answers.create(custom_field: @date, value: '1/15/2008')
    @p3.custom_field_answers.create(custom_field: @date, value: '2/7/2011')
    @p4.custom_field_answers.create(custom_field: @date, value: '8/5/2009')
    @p5.custom_field_answers.create(custom_field: @date, value: '6/7/2010')
  end

  test '.fields' do
    assert_equal 3, CustomField.count
    assert_equal ["Name", "Price", "#{@text.name}", "#{@date.name}", "#{@number.name}"], ProductGroup.fields.map { |r| r['name'] }
    assert_equal ["text", "number", "text", "date", "number"], ProductGroup.fields.map { |r| r['field_type'] }
  end

  test "returns products using equality operator" do
    group = create(:product_group)
    condition = group.product_group_conditions.build(name: @text.id)

    condition.operator = 'eq'
    condition.value = 'george washington'
    assert_equal [ @p1 ], group.products
    assert_equal "#{@text.name} is equal to george washington", group.summarize

    condition.value = 'george murphy'
    assert_equal [ @p2 ], group.products

    condition.value = 'steve jobs'
    assert_equal [ @p3 ], group.products

    condition.value = 'bill gates'
    assert_equal [ @p4 ], group.products
  end

  test "returns products using starts with operator" do
    group = create(:product_group)
    condition = group.product_group_conditions.build(name: @text.id)
    condition.operator = 'starts'

    condition.value = 'george'
    assert_equal [ @p1, @p2 ], group.products
    assert_equal "#{@text.name} starts with 'george'", group.summarize

    condition.value = 'steve'
    assert_equal [ @p3 ], group.products

    condition.value = 'bill gates'
    assert_equal [ @p4 ], group.products

    condition.value = 'george m'
    assert_equal [ @p2 ], group.products
  end

  test "returns products using ends with operator" do
    group = create(:product_group)
    condition = group.product_group_conditions.build(name: @text.id)
    condition.operator = 'ends'

    condition.value = 'murphy'
    assert_equal [ @p2 ], group.products
    assert_equal "name4 ends with 'murphy'", group.summarize

    condition.value = 'jobs'
    assert_equal [ @p3 ], group.products

    condition.value = 'bill gates'
    assert_equal [ @p4 ], group.products
  end

  test "show results to equality operator" do
    group     = create(:product_group)
    condition = group.product_group_conditions.create(name: @number.id.to_s, operator: 'eq', value: 23)

    assert_equal [ @p1 ], group.products
    condition.value = 73
    assert_equal [ @p2 ], group.products
  end

  test "returs products with multiple vlaues" do
    group     = create(:product_group)
    group.product_group_conditions.create(name: @number.id.to_s, operator: 'lt', value: 25)
    group.product_group_conditions.create(name: @text.id.to_s, operator: 'starts', value: 'george')

    assert_equal [ @p1 ], group.products
  end
end
