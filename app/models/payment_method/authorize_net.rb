class PaymentMethod::AuthorizeNet < PaymentMethod

  preference :login_id,                             :string
  preference :transaction_key,                      :string
  preference :company_name_on_creditcard_statement, :string

  def gateway
    set_mode
    gateway_klass.logger = Rails.logger unless Rails.env.production?
    ::BinaryMerchant::AuthorizeNetGateway.new( gateway_klass.new(credentials) )
  end

  private

  def credentials
    { login: self.preferred_login_id , password: self.preferred_transaction_key }
  end

  def gateway_klass
    if Rails.env.test?
      ActiveMerchant::Billing::AuthorizeNetMockedGateway
    else
      ActiveMerchant::Billing::AuthorizeNetGateway
    end
  end

end
