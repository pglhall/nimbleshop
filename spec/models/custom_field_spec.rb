require 'spec_helper'

describe CustomField do
  describe "validations " do
    subject { create(:custom_field, field_type: 'number') } 
    it {
      must validate_presence_of(:name)
      must allow_value("number").for(:field_type)
      must allow_value("text").for(:field_type)
      must allow_value("date").for(:field_type)
      wont allow_value("boolean").for(:field_type)
    }
  end
end
