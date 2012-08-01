module NimbleshopAuthorizedotnet
  module Gateway
    def self.instance
      payment_method = NimbleshopAuthorizedotnet::Authorizedotnet.first

      ActiveMerchant::Billing::Gateway.logger = Rails.logger if payment_method.mode.to_s == 'test'

      ActiveMerchant::Billing::AuthorizeNetGateway.new( payment_method.credentials )
    end
  end
end
