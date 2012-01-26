class PaymentMethod::AuthorizeNet < PaymentMethod

  store_accessor :settings, :authorize_net_login_id, :authorize_net_transaction_key,
                            :authorize_net_company_name_on_creditcard_statement

  def gateway
    set_mode
    gateway_klass.logger = Rails.logger unless Rails.env.production?
    ::BinaryMerchant::AuthorizeNetGateway.new( gateway_klass.new(credentials) )
  end

  private

  def credentials
    { login: self.authorize_net_login_id , password: self.authorize_net_transaction_key }
  end

  def gateway_klass
    if Rails.env.test?
      ActiveMerchant::Billing::AuthorizeNetMockedGateway
    else
      ActiveMerchant::Billing::AuthorizeNetGateway
    end
  end

end
