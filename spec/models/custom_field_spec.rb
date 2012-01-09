require 'spec_helper'

describe CustomField do
  let(:custom_field) { build(:custom_field) }

  it "needs require name" do
    custom_field.name = nil
    custom_field.must_be(:invalid?)
    custom_field.errors[:name].wont_be_nil
  end

  it "needs field_type be 'text,number,date'" do
    custom_field.field_type = "text"
    custom_field.must_be(:valid?)

    custom_field.field_type = "number"
    custom_field.must_be(:valid?)

    custom_field.field_type = "date"
    custom_field.must_be(:valid?)

    custom_field.field_type = "boolean"
    custom_field.wont_be(:valid?)
  end
end
