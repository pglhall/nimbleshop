require 'spec_helper'

describe Address do

  describe "#validations" do
    let(:address) { build(:address) }
    it {
      address.wont have_valid(:first_name).when(nil)
      address.wont have_valid(:last_name).when(nil)
      address.wont have_valid(:address1).when(nil)
      address.wont have_valid(:country_code).when(nil)
      address.wont have_valid(:zipcode).when(nil)
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
