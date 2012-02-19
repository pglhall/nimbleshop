require 'spec_helper'

describe Address do

  describe "#validations" do
    subject { create(:address) }
    it {
      must validate_presence_of(:first_name)
      must validate_presence_of(:last_name)
      must validate_presence_of(:address1)
      must validate_presence_of(:zipcode)
      must validate_presence_of(:country_code)
      must validate_presence_of(:city)
    }
  end

  describe "#set_country_name" do
    it {
      address = create(:address, country_code: 'IN', state_code: 'AP')
      address.country_name.must_equal "India"
    }
  end

  describe "#set_state_name" do
    describe "happy path" do
      it {
        address = create(:address, country_code: 'US', state_code: 'MD')
        address.country_name.must_equal "United States"
        address.state_name.must_equal "Maryland"
      }
    end
    describe "error path" do
      it {
        address = build(:address, country_code: 'BR', state_code: nil, state_name: nil)
        address.valid?
        address.country_name.must_equal "Brazil"
        address.errors.full_messages.first.must_equal "State code is required"
      }
      it {
        address = build(:address, country_code: 'BR', state_code: 'XX')
        address.valid?
        address.country_name.must_equal "Brazil"
        address.errors.full_messages.first.must_equal "State code XX is not a valid state"
      }
    end
  end

end
