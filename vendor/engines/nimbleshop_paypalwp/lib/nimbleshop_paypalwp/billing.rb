module NimbleshopPaypalwp
  class Billing < Billing::Base
    attr_reader :order

    def initialize(options = {})
      @paypal_ipn = paypal_ipn(options[:raw_post])
      @order = Order.find(@paypal_ipn.invoice)
    end

    private

    def set_active_merchant_mode
      record = NimbleshopPaypalwp::Paypalwp.first
      ActiveMerchant::Billing::Base.mode = record.mode.to_sym
    end

    def do_capture(options = {})
      success = amount_match?
      record_transaction('captured', success: success)

      if success
        order.update_attributes(paid_at: paid_at, payment_method: NimbleshopPaypalwp::Paypalwp.first)
        order.kapture
      end

      success
    end

    def do_authorize(options = {})
      success = amount_match?
      record_transaction('authorized', success: success)

      if success
        order.update_attributes(paid_at: paid_at, payment_method: NimbleshopPaypalwp::Paypalwp.first)
        order.authorize
      end

      success
    end

    def do_void(options = {})
    end

    def do_purchase(options = {})
      success = amount_match?
      record_transaction('purchased', success: success)

      if success
        order.update_attributes(paid_at: @paypal_ipn.received_at,
                                payment_method: NimbleshopPaypalwp::Paypalwp.first)
        order.purchase
      end

      success
    end

    def paypal_ipn(raw_post)
      ActiveMerchant::Billing::Integrations::Paypal::Notification.new(raw_post)
    end

    def record_transaction(operation, options = {})
      order.payment_transactions.create(options.merge(amount: @paypal_ipn.amount.cents,
                                                      params: { ipn: @paypal_ipn.raw },
                                                      transaction_gid: @paypal_ipn.transaction_id,
                                                      operation: operation))

    end

    def amount_match?
      @paypal_ipn.amount.cents == order.total_amount_in_cents
    end

    # TODO where is it being used ??
    def acknowledge
      @paypal_ipn.acknowledge
    end

    def paid_at
      Time.strptime(@paypal_ipn.params['payment_date'], "%H:%M:%S %b %d, %Y %z")
    end
  end
end
