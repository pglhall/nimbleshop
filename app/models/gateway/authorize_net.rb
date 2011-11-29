class Gateway::AuthorizeNet < Gateway

  # Indicates if the required credential information is provided.
  def self.credentials?
    self.credentials.values.compact.size == 2
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
    login = ENV['GATEWAY_AUTHORIZE_NET_LOGIN_ID'] || Settings.gateway_authorize_net_login_id
    transaction_key =  ENV['GATEWAY_AUTHORIZE_NET_TRANSACTION_KEY'] || Settings.gateway_authorize_net_transaction_key
    { login: login , password: transaction_key }
  end

  def self.gateway_klass
    if Rails.env.test?
      ActiveMerchant::Billing::AuthorizeNetMockedGateway
    else
      ActiveMerchant::Billing::AuthorizeNetGateway
    end
  end

end
