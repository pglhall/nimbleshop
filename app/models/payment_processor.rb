class PaymentProcessor

  attr_reader :order, :creditcard
  delegate :valid?, to: :creditcard

  def initialize(creditcard, order)
    @order      = order
    @creditcard = creditcard
  end

  def process
    valid? ? send(default_creditcard_action) : false
  end

  private

    def default_creditcard_action
      Shop.first.default_creditcard_action
    end

    def purchase
      handle_action(:purchase, :transaction_purchased)
    end

    def authorize
      handle_action(:authorize, :transaction_authorized)
    end

    def handle_action(action, transition)
      if gateway_processor.send(action)
        order.update_attributes(payment_method: payment_method)
        order.send(transition)
      else
        creditcard.errors.add(:base, 'Credit card was declined. Please try again! ')
      end
    end

    def gateway_processor
      GatewayProcessor.new(payment_method: payment_method, creditcard: creditcard, order: order)
    end

    def payment_method
      PaymentMethod.find_by_permalink!('authorize-net')
    end
end
