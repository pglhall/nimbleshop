require 'test_helper'

class PaymentMethodSplitableTest < ActiveSupport::TestCase

  test "validations" do
    pm = NimbleshopSplitable::Splitable.new(name: 'Splitable', description: 'this is description')
    refute pm.valid?
    assert_equal ["Api key can't be blank"], pm.errors.full_messages.sort
  end

  test "should save the record" do
    pm = NimbleshopSplitable::Splitable.new(name: 'Splitable', description: 'this is description')
    pm.api_key = 'FWERSDEED093d'
    assert pm.save
    assert_match /splitable/, pm.permalink
  end

end
