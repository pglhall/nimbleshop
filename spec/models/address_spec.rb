require 'spec_helper'

describe Address do

  describe "#validations" do
    let(:address) { build(:address) }

    it {
      address.wont have_valid(:first_name).when(nil)
      address.wont have_valid(:last_name).when(nil)
      address.wont have_valid(:address1).when(nil)
      address.wont have_valid(:state).when(nil)
      address.wont have_valid(:country).when(nil)
      address.wont have_valid(:zipcode).when(nil)
    }
  end
end
