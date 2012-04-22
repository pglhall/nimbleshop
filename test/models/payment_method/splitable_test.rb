require 'test_helper'

class PaymentMethodSplitable < ActiveSupport::TestCase

  test "validations" do
    pm = PaymentMethod::Splitable.new(name: 'Splitable', description: 'this is description')
    refute pm.valid?
    assert_equal 1, pm.errors.size
  end

  test "should save the record" do
    pm = PaymentMethod::Splitable.new(name: 'Splitable', description: 'this is description')
    pm.splitable_api_key = 'FWERSDEED093d'
    pm.save!
    assert_match /splitable/, pm.permalink
  end

end
