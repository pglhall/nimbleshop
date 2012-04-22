require "test_helper"

class PaymentMethodAuthorizeNetTest < ActiveSupport::TestCase

  test "validations" do
    pm = PaymentMethod::AuthorizeNet.new(name: 'Authorize.net', description: 'this is description')
    refute pm.valid?
    assert_equal 3, pm.errors.size
  end

  test "should save the record" do
    pm = PaymentMethod::AuthorizeNet.new(name: 'Authorize.net', description: 'this is description')
    pm.authorize_net_login_id = 'FWERSDEED093d'
    pm.authorize_net_transaction_key = 'SDFSDFSFSF423433SDFSFSSFSFSF334'
    pm.authorize_net_company_name_on_creditcard_statement = 'BigBinary LLC'
    pm.save!
    assert_match /authorize-net/, pm.permalink
  end

end
