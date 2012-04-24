class PaymentMethod::AuthorizeNet < PaymentMethod

  store_accessor :settings, :authorize_net_login_id,
                            :authorize_net_transaction_key,
                            :authorize_net_use_ssl,
                            :authorize_net_company_name_on_creditcard_statement

  validates_presence_of :authorize_net_login_id, :authorize_net_transaction_key, :authorize_net_company_name_on_creditcard_statement

  def gateway
    set_mode
    ActiveMerchant::Billing::AuthorizeNetGateway.new(credentials)
  end

  def extract_transaction_id(response)
    response.success? ? response.params['transaction_id'] : nil
  end

  def use_ssl
    self.settings[:authorize_net_use_ssl]
  end

  private

    def credentials
      { login: authorize_net_login_id, password: authorize_net_transaction_key }
    end
end
