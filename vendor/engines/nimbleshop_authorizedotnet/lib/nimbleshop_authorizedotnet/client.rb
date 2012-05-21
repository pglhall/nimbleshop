module NimbleshopAuthorizedotnet
  module Client
    def self.instance
      ActiveMerchant::Billing::Gateway.logger = Rails.logger unless Rails.env.production?
      ActiveMerchant::Billing::AuthorizeNetGateway.new( NimbleshopAuthorizedotnet::Authorizedotnet.first.credentials )
    end
  end
end
