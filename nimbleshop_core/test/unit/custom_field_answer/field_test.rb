require "test_helper"

class CustomFieldAnswerFieldNumberTest < ActiveSupport::TestCase

  setup do
    @custom_field = CustomField.new(field_type: 'number')
  end

  test "when custom_field set during build" do
    answer = CustomFieldAnswer.new(custom_field: @custom_field, value: 234)
    assert_equal 234, answer.number_value
  end

  test "when custom_field set after build" do
    answer = CustomFieldAnswer.new(value: 234)
    answer.custom_field = @custom_field
    assert_equal 234, answer.number_value
  end

  test "when custom_field_id set after build" do
    answer = CustomFieldAnswer.new(value: 234)
    answer.custom_field_id = create(:number_custom_field).id
    assert_equal 234, answer.number_value
  end

  test "when custom_field_id set during build" do
    answer = CustomFieldAnswer.new(value: 234, custom_field_id: create(:number_custom_field).id)
    answer.custom_field_id = create(:number_custom_field)
    assert_equal 234, answer.number_value
  end

end

class CustomFieldAnswerFieldTextTest < ActiveSupport::TestCase

  setup do
    @custom_field = CustomField.new(field_type: 'text')
  end

  test "when custom field set during build" do
    answer = CustomFieldAnswer.new(custom_field: @custom_field, value: 'string')
    assert_equal 'string', answer.value
  end

  test "when custom field set after build" do
    answer = CustomFieldAnswer.new(value: 'string')
    answer.custom_field = @custom_field
    assert_equal 'string', answer.value
  end

  test "when custom_field_id set during build" do
    answer = CustomFieldAnswer.new(custom_field_id: create(:text_custom_field).id, value: 'string')
    assert_equal 'string', answer.value
  end

  test "when custom_field_id set after build" do
    answer = CustomFieldAnswer.new(value: 'string')
    answer.custom_field_id = create(:text_custom_field).id
    assert_equal 'string', answer.value
  end

end


class CustomFieldAnswerFieldDateTest < ActiveSupport::TestCase

  setup do
    @custom_field = CustomField.new(field_type: 'date')
  end

  test "when custom field set during build" do
    answer = CustomFieldAnswer.new(custom_field: @custom_field, value: '2/4/2009')
    assert_equal '02/04/2009', answer.datetime_value.strftime("%m/%d/%Y")
  end

  test "when custom field set after build" do
    answer = CustomFieldAnswer.new(value: '2/4/2009')
    answer.custom_field = @custom_field
    assert_equal '02/04/2009', answer.datetime_value.strftime("%m/%d/%Y")
  end

  test "when custom_field_id set during build" do
    answer = CustomFieldAnswer.new(custom_field_id: create(:date_custom_field).id, value: '2/4/2009')
    assert_equal '02/04/2009', answer.datetime_value.strftime("%m/%d/%Y")
  end

  test "when custom_field_id set after build" do
    answer = CustomFieldAnswer.new(value: '2/4/2009')
    answer.custom_field_id = create(:date_custom_field).id
    assert_equal '02/04/2009', answer.datetime_value.strftime("%m/%d/%Y")
  end

end
