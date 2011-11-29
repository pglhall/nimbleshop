class Gateway::AuthorizeNet < Gateway

  # Indicates if the required credential information is provided.
  def self.credentials?
    Settings.gateway_authorize_net_login_id && Settings.gateway_authorize_net_transaction_key
  end

  def self.instance
    @gateway ||= begin
      set_mode
      gateway_klass.logger = Rails.logger unless Rails.env.production?
      ::BinaryMerchant::AuthorizeNetGateway.new( gateway_klass.new(credentials) )
    end
  end

  private

  def self.credentials
    { login:    Settings.gateway_authorize_net_login_id ,
      password: Settings.gateway_authorize_net_transaction_key }
  end

  def self.gateway_klass
    if Rails.env.test?
      ActiveMerchant::Billing::AuthorizeNetMockedGateway
    else
      ActiveMerchant::Billing::AuthorizeNetGateway
    end
  end

end
