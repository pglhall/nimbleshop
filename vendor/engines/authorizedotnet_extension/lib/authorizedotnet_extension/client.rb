module AuthorizedotnetExtension
  module Client
    def self.instance
      ActiveMerchant::Billing::AuthorizeNetGateway.new(PaymentMethod::AuthorizeNet.first.credentials)
    end
  end
end
