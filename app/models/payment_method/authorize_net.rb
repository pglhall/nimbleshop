class PaymentMethod::AuthorizeNet < PaymentMethod

  attr_accessor :login_id, :transaction_key

  def gateway
    set_mode
    gateway_klass.logger = Rails.logger unless Rails.env.production?
    ::BinaryMerchant::AuthorizeNetGateway.new( gateway_klass.new(credentials) )
  end

  private

  def credentials
    { login: self.login_id , password: self.transaction_key }
  end

  def gateway_klass
    if Rails.env.test?
      ActiveMerchant::Billing::AuthorizeNetMockedGateway
    else
      ActiveMerchant::Billing::AuthorizeNetGateway
    end
  end

  def set_data
    self.data = {login_id: @login_id, transaction_key: @transaction_key}
  end

end
