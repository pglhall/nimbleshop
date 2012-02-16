class PaymentProcessor
  attr_accessor :order, :creditcard, :gateway_processor, :payment_method, :amount

  def initialize(_amount, _creditcard, _order)
    @amount = _amount
    @creditcard = _creditcard
    @order = _order
    @payment_method = PaymentMethod.find_by_permalink!('authorize-net')
    @gateway_processor = build_gateway_processor
  end

  def purchase
    handle_action(:purchase, :purchased)
  end

  def authorize
    handle_action(:authorize, :authorized)
  end

  def handle_action(action, status)
    if gateway_processor.send(action)
      order.send(status)
      order.update_attributes!(payment_method: payment_method)
    else
      creditcard.errors.add(:base, 'Credit card was declined. Please try again! ')
    end
  end

  def build_gateway_processor
    GatewayProcessor.new(payment_method_permalink: 'authorize-net',
                        amount: amount,
                        creditcard: creditcard,
                        order: order)
  end
end

