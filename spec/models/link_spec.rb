require 'spec_helper'

describe Link do
  describe "validations" do
    subject { create(:link) }
    it {
      must validate_presence_of(:name)
      must validate_presence_of(:url)
    }
  end
end
