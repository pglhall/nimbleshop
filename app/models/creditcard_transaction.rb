class CreditcardTransaction < ActiveRecord::Base

  belongs_to :creditcard

  def capture(options)
    GatewayProcessor.new( payment_method_permalink: options.fetch(:payment_method_permalink),
                          creditcard: creditcard,
                          amount: amount).capture(self)
  end

end
