require 'spec_helper'

describe CustomFieldAnswer::Field do
  describe "when question is number type" do
    let(:custom_field)  { CustomField.new(field_type: 'number') }

    describe "when custom_field set during build" do
      let(:answer)  { CustomFieldAnswer.new(custom_field: custom_field, value: 234) }
      it "must set integer_value" do
        answer.number_value.must_equal 234
      end
    end

    describe "when custom_field set after build" do
      let(:answer)  { CustomFieldAnswer.new(value: 234) }
      it "must set integer_value" do
        answer.custom_field = custom_field
        answer.number_value.must_equal 234
      end
    end

    describe "when custom_field_id set after build" do
      let(:answer)  { CustomFieldAnswer.new(value: 234) }
      it "must set integer_value" do
        answer.custom_field_id = create(:number_custom_field).id
        answer.number_value.must_equal 234
      end
    end

    describe "when custom_field_id set during build" do
      let(:answer)  { CustomFieldAnswer.new(value: 234, custom_field_id: create(:number_custom_field).id) }
      it "must set integer_value" do
        answer.custom_field_id = create(:number_custom_field)
        answer.number_value.must_equal 234
      end
    end
  end

  describe "when question is text type" do
    let(:custom_field)  { CustomField.new(field_type: 'text') }

    describe "when custom field set during build" do
      let(:answer)  { CustomFieldAnswer.new(custom_field: custom_field, value: 'string') }
      it "must set value" do
        answer.value.must_equal 'string'
      end
    end

    describe "when custom field set after build" do
      let(:answer)  { CustomFieldAnswer.new(value: 'string') }
      it "must set value" do
        answer.custom_field = custom_field
        answer.value.must_equal 'string'
      end
    end

    describe "when custom_field_id set during build" do
      let(:answer)  { CustomFieldAnswer.new(custom_field_id: create(:text_custom_field).id, value: 'string') }
      it "must set value" do
        answer.value.must_equal 'string'
      end
    end

    describe "when custom_field_id set after build" do
      let(:answer)  { CustomFieldAnswer.new(value: 'string') }
      it "must set value" do
        answer.custom_field_id = create(:text_custom_field).id
        answer.value.must_equal 'string'
      end
    end
  end

  describe "when question is date type" do
    let(:custom_field)  { CustomField.new(field_type: 'date') }

    describe "when custom field set during build" do
      let(:answer)  { CustomFieldAnswer.new(custom_field: custom_field, value: '2/4/2009') }
      it "must set integer_value" do
        answer.datetime_value.strftime("%m/%d/%Y").must_equal '02/04/2009'
      end
    end

    describe "when custom field set after build" do
      let(:answer)  { CustomFieldAnswer.new(value: '2/4/2009') }
      it "must set date_value" do
        answer.custom_field = custom_field
        answer.datetime_value.strftime("%m/%d/%Y").must_equal '02/04/2009'
      end
    end

    describe "when custom_field_id set during build" do
      let(:answer)  { CustomFieldAnswer.new(custom_field_id: create(:date_custom_field).id, value: '2/4/2009') }
      it "must set integer_value" do
        answer.datetime_value.strftime("%m/%d/%Y").must_equal '02/04/2009'
      end
    end

    describe "when custom_field_id set after build" do
      let(:answer)  { CustomFieldAnswer.new(value: '2/4/2009') }
      it "must set date_value" do
        answer.custom_field_id = create(:date_custom_field).id
        answer.datetime_value.strftime("%m/%d/%Y").must_equal '02/04/2009'
      end
    end
  end
end
