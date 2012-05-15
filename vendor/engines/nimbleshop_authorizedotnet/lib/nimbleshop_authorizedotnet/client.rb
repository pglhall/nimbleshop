module NimbleshopAuthorizedotnet
  module Client
    def self.instance
      ActiveMerchant::Billing::AuthorizeNetGateway.new( NimbleshopAuthorizedotnet::Authorizedotnet.first.credentials )
    end
  end
end
