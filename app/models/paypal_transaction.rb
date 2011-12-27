class PaypalTransaction < ActiveRecord::Base

  def capture(options)
    _amount  = options[:amount] || self.amount
    GatewayProcessor.new(payment_method_permalink: options.fetch(:payment_method_permalink)).capture(_amount, self)
  end

end
