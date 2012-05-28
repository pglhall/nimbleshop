module NimbleshopAuthorizedotnet
  module Client
    def self.instance
      record = NimbleshopAuthorizedotnet::Authorizedotnet.first

      ActiveMerchant::Billing::Gateway.logger = Rails.logger if record.mode.to_s == 'test'

      ActiveMerchant::Billing::AuthorizeNetGateway.new( record.credentials )
    end
  end
end
