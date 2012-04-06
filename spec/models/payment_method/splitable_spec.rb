require 'spec_helper'

describe PaymentMethod::Splitable do

  describe "should have validation" do
    it {
      pm = PaymentMethod::Splitable.new(name: 'Splitable', description: 'this is description')
      refute pm.valid?
      assert_equal 1, pm.errors.size
    }
  end

  describe "should save the record" do
    it {
      pm = PaymentMethod::Splitable.new(name: 'Splitable', description: 'this is description')
      pm.splitable_api_key = 'FWERSDEED093d'
      pm.save!
      assert_match /splitable/, pm.permalink
    }
  end

end
