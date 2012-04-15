require "test_helper"

class CustomFieldAnswerFieldNumberTest < ActiveSupport::TestCase

  setup do
    @custom_field = CustomField.new(field_type: 'number')
  end

  test "when custom_field set during build" do
    answer = CustomFieldAnswer.new(custom_field: @custom_field, value: 234)
    answer.number_value.must_equal 234
  end

  test "when custom_field set after build" do
    answer = CustomFieldAnswer.new(value: 234)
    answer.custom_field = @custom_field
    answer.number_value.must_equal 234
  end

  test "when custom_field_id set after build" do
    answer = CustomFieldAnswer.new(value: 234)
    answer.custom_field_id = create(:number_custom_field).id
    answer.number_value.must_equal 234
  end

  test "when custom_field_id set during build" do
    answer = CustomFieldAnswer.new(value: 234, custom_field_id: create(:number_custom_field).id)
    answer.custom_field_id = create(:number_custom_field)
    answer.number_value.must_equal 234
  end

end

class CustomFieldAnswerFieldTextTest < ActiveSupport::TestCase

  setup do
    @custom_field = CustomField.new(field_type: 'text')
  end

  test "when custom field set during build" do
    answer = CustomFieldAnswer.new(custom_field: @custom_field, value: 'string')
    answer.value.must_equal 'string'
  end

  test "when custom field set after build" do
    answer = CustomFieldAnswer.new(value: 'string')
    answer.custom_field = @custom_field
    answer.value.must_equal 'string'
  end

  test "when custom_field_id set during build" do
    answer = CustomFieldAnswer.new(custom_field_id: create(:text_custom_field).id, value: 'string')
    answer.value.must_equal 'string'
  end

  test "when custom_field_id set after build" do
    answer = CustomFieldAnswer.new(value: 'string')
    answer.custom_field_id = create(:text_custom_field).id
    answer.value.must_equal 'string'
  end

end


class CustomFieldAnswerFieldDateTest < ActiveSupport::TestCase

  setup do
    @custom_field = CustomField.new(field_type: 'date')
  end

  test "when custom field set during build" do
    answer = CustomFieldAnswer.new(custom_field: @custom_field, value: '2/4/2009')
    answer.datetime_value.strftime("%m/%d/%Y").must_equal '02/04/2009'
  end

  test "when custom field set after build" do
    answer = CustomFieldAnswer.new(value: '2/4/2009')
    answer.custom_field = @custom_field
    answer.datetime_value.strftime("%m/%d/%Y").must_equal '02/04/2009'
  end

  test "when custom_field_id set during build" do
    answer = CustomFieldAnswer.new(custom_field_id: create(:date_custom_field).id, value: '2/4/2009')
    answer.datetime_value.strftime("%m/%d/%Y").must_equal '02/04/2009'
  end

  test "when custom_field_id set after build" do
    answer = CustomFieldAnswer.new(value: '2/4/2009')
    answer.custom_field_id = create(:date_custom_field).id
    answer.datetime_value.strftime("%m/%d/%Y").must_equal '02/04/2009'
  end

end
