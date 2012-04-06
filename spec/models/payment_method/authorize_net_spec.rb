require 'spec_helper'

describe PaymentMethod::AuthorizeNet do

  describe "should have validation" do
    it {
      pm = PaymentMethod::AuthorizeNet.new(name: 'Authorize.net', description: 'this is description')
      refute pm.valid?
      assert_equal 3, pm.errors.size
    }
  end

  describe "should save the record" do
    it {
      pm = PaymentMethod::AuthorizeNet.new(name: 'Authorize.net', description: 'this is description')
      pm.authorize_net_login_id = 'FWERSDEED093d'
      pm.authorize_net_transaction_key = 'SDFSDFSFSF423433SDFSFSSFSFSF334'
      pm.authorize_net_company_name_on_creditcard_statement = 'BigBinary LLC'
      pm.save!
      assert_match /authorize-net/, pm.permalink
    }
  end

end
